#!/usr/bin/bash

tpm_notinstalled="No TPM chip found"
tpm1_installed="---- UNKNOWN AT THIS TIME ------"
tpm2_installed="kernel: tpm_tis"

if [ -f /bin/journalctl ]; then
    get_tpm_tis=$(journalctl --boot --system | grep --extended-regexp --ignore-case ' tpm ')
    printf "\nDEBUG: get_tpm_tis --> %s\n" "$get_tpm_tis"
    if [ -z "$get_tpm_tis" ]; then
        get_tpm_tis=$(/bin/dmesg --facility kern | grep --extended-regexp --ignore-case ' tpm ')
        printf "\nDEBUG: get_tpm_tis --> %s\n" "$get_tpm_tis"
    fi
else
    echo "SOMETHING WENT WRONG HERE"
    exit 1
fi

case "$get_tpm_tis" in
        *"$tpm_notinstalled"*) echo "TPM Not Installed";;
        *"$tpm1_installed"*) echo "TPM1 Installed";;
        *"$tpm2_installed"*) echo "TPM2 Installed";;
        *) echo "TPM value NOT FOUND";;
esac

