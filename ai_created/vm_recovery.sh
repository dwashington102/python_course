#!/usr/bin/env bash
set -euo pipefail

IMAGES_DIR="/var/lib/libvirt/images"
MOUNT_POINT="/mnt/backup"
MAPPER_NAME="vm_recovery_luks"
NBD_DEV=""
UNLOCKED_MAPPER=""

cleanup_on_error() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo ""
        echo "[!] Script exited with error ($exit_code). Cleaning up partial mounts/mappings..." >&2
        if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
            umount "$MOUNT_POINT" 2>/dev/null || true
        fi
        if [[ -n "$UNLOCKED_MAPPER" && -e "/dev/mapper/$UNLOCKED_MAPPER" ]]; then
            cryptsetup luksClose "$UNLOCKED_MAPPER" 2>/dev/null || true
        fi
        if [[ -n "$NBD_DEV" ]]; then
            qemu-nbd --disconnect "$NBD_DEV" 2>/dev/null || true
        fi
    fi
}
trap cleanup_on_error EXIT

# 1) Confirm the script is being called by the root user
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Error: This script must be run as root (try: sudo $0)" >&2
    exit 1
fi

# 2) Confirm there are qcow2 files in /var/lib/libvirt/images
if [[ ! -d "$IMAGES_DIR" ]]; then
    echo "Error: Images directory '$IMAGES_DIR' does not exist." >&2
    exit 1
fi

mapfile -t qcow2_files < <(find "$IMAGES_DIR" -maxdepth 1 -type f -name "*.qcow2" | sort)

if [[ ${#qcow2_files[@]} -eq 0 ]]; then
    echo "Error: No .qcow2 files found in '$IMAGES_DIR'." >&2
    exit 1
fi

# 3) Allow the user to select which qcow2 file should be mounted
echo "Available .qcow2 images in $IMAGES_DIR:"
for i in "${!qcow2_files[@]}"; do
    size_human="$(du -h "${qcow2_files[$i]}" | cut -f1)"
    printf "  [%d] %s (%s)\n" "$((i + 1))" "$(basename "${qcow2_files[$i]}")" "$size_human"
done

selected_file=""
while [[ -z "$selected_file" ]]; do
    read -r -p "Enter the number of the qcow2 file to mount [1-${#qcow2_files[@]}]: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#qcow2_files[@]} )); then
        selected_file="${qcow2_files[$((choice - 1))]}"
    else
        echo "Invalid selection. Please enter a number between 1 and ${#qcow2_files[@]}."
    fi
done

echo "Selected: $selected_file"

# Verify qemu-nbd is available
if ! command -v qemu-nbd >/dev/null 2>&1; then
    echo "Error: 'qemu-nbd' is not installed. Install 'qemu-img' package first." >&2
    exit 1
fi

# 4) Load the necessary kernel module that allows loading qcow2 files
echo "Loading 'nbd' kernel module..."
modprobe nbd max_part=16

# Find a free /dev/nbdX device not currently connected to a PID
for dev in /dev/nbd[0-9]*; do
    [[ -b "$dev" ]] || continue
    dev_name="$(basename "$dev")"
    if [[ ! -f "/sys/block/$dev_name/pid" ]]; then
        NBD_DEV="$dev"
        break
    fi
done

if [[ -z "$NBD_DEV" ]]; then
    echo "Error: No free /dev/nbd* device found." >&2
    exit 1
fi

echo "Connecting '$selected_file' to '$NBD_DEV' (read-only for data safety)..."
printf "DEBUG >>> qemu-nbd -r attempt\n"
qemu-nbd -r --connect="$NBD_DEV" "$selected_file" -f qcow2
printf "DEBUG >>> qemu-nbd -r results rc=$?\n"
udevadm settle

# 5) Check if the qcow2 file (or any partition inside it) is encrypted with LUKS
candidate_devs=("$NBD_DEV")
for part in "${NBD_DEV}"p*; do
    [[ -b "$part" ]] && candidate_devs+=("$part")
done

luks_devs=()
for cdev in "${candidate_devs[@]}"; do
    if cryptsetup isLuks "$cdev" >/dev/null 2>&1; then
        luks_devs+=("$cdev")
    fi
done

target_mount_source=""

if [[ ${#luks_devs[@]} -gt 0 ]]; then
    echo "LUKS encryption detected on: ${luks_devs[*]}"

    luks_target=""
    if [[ ${#luks_devs[@]} -eq 1 ]]; then
        luks_target="${luks_devs[0]}"
    else
        echo "Multiple LUKS containers found:"
        for i in "${!luks_devs[@]}"; do
            printf "  [%d] %s\n" "$((i + 1))" "${luks_devs[$i]}"
        done
        while [[ -z "$luks_target" ]]; do
            read -r -p "Select LUKS device to unlock [1-${#luks_devs[@]}]: " lchoice
            if [[ "$lchoice" =~ ^[0-9]+$ ]] && (( lchoice >= 1 && lchoice <= ${#luks_devs[@]} )); then
                luks_target="${luks_devs[$((lchoice - 1))]}"
            else
                echo "Invalid selection."
            fi
        done
    fi

    # 6) If encrypted with LUKS, unlock the LUKS container (read-only)
    if [[ -e "/dev/mapper/$MAPPER_NAME" ]]; then
        cryptsetup luksClose "$MAPPER_NAME"
    fi

    echo "Unlocking LUKS container '$luks_target' as /dev/mapper/$MAPPER_NAME..."
    cryptsetup --allow-discards --readonly open "$luks_target" "$MAPPER_NAME"
    UNLOCKED_MAPPER="$MAPPER_NAME"
    udevadm settle
    target_mount_source="/dev/mapper/$MAPPER_NAME"
else
    echo "No LUKS encryption detected."
    # Prefer a partition if partitions exist, otherwise use the whole NBD device
    if (( ${#candidate_devs[@]} > 1 )); then
        echo "Detected block devices/partitions:"
        for i in "${!candidate_devs[@]}"; do
            fstype="$(blkid -o value -s TYPE "${candidate_devs[$i]}" 2>/dev/null || echo "unknown/container")"
            size_human="$(lsblk -dn -o SIZE "${candidate_devs[$i]}" 2>/dev/null | xargs || echo "?")"
            printf "  [%d] %s (type: %s, size: %s)\n" "$((i + 1))" "${candidate_devs[$i]}" "$fstype" "$size_human"
        done
        while [[ -z "$target_mount_source" ]]; do
            read -r -p "Select device or partition to mount [1-${#candidate_devs[@]}]: " pchoice
            if [[ "$pchoice" =~ ^[0-9]+$ ]] && (( pchoice >= 1 && pchoice <= ${#candidate_devs[@]} )); then
                target_mount_source="${candidate_devs[$((pchoice - 1))]}"
            else
                echo "Invalid selection."
            fi
        done
    else
        target_mount_source="$NBD_DEV"
    fi
fi

# 7) Mount the qcow2 file/volume to /mnt/backups
mkdir -p "$MOUNT_POINT"
if mountpoint -q "$MOUNT_POINT"; then
    echo "Error: '$MOUNT_POINT' is already mounted. Unmount it first." >&2
    exit 1
fi

fstype="$(blkid -o value -s TYPE "$target_mount_source" 2>/dev/null || true)"
mount_opts="ro"
if [[ "$fstype" == "xfs" ]]; then
    # XFS often requires nouuid when mounting a cloned/disk-image filesystem on the host
    mount_opts="ro,nouuid"
fi

echo "Mounting '$target_mount_source' (fstype: ${fstype:-auto}) to '$MOUNT_POINT'..."
mount -o "$mount_opts" "$target_mount_source" "$MOUNT_POINT"

echo ""
echo "Success! Image mounted at: $MOUNT_POINT"
echo "Copy critical files to your host, then clean up with:"
echo "  sudo umount $MOUNT_POINT"
[[ -n "$UNLOCKED_MAPPER" ]] && echo "  sudo cryptsetup luksClose $UNLOCKED_MAPPER"
echo "  sudo qemu-nbd --disconnect $NBD_DEV"
