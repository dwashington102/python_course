#!/usr/bin/bash

:<<'WARNING'
The purpose of this script is to remove outdated/unwanted kernels from /usr/lib/modules
There is no way this script should be run in Production without full filesystem backups
being available.

This is what happens when you wake up at 4 in the morning and realize "hey /usr/lib/modules"
has a lot more then 3 directories".

Steps to take before running this script:
1) Confirm system can be restored from backup
2) Confirm "installonly_limit" setting in the /etc/dnf/dnf.conf is being used
WARNING

# Gather the max. number of kernels setting from dnf.conf
get_limit_value (){
    limit_value=$(grep installonly /etc/dnf/dnf.conf | awk -F"=" '{print $2}')
    printf "\nDEBUG >>> dnf.conf max. number of kernels - %s" "$limit_value"
}

# Gather the total  number of "kernel-core" rpms installed
get_rpms_installed (){
    kernel_rpms=( $(rpm -qa | grep ^kernel-core) )
    printf "\nDEBUG >>> Number of kernel RPMS - %s" "${#kernel_rpms[@]}"
}

# Gather the total number of subdirectories in /usr/lib/module
get_dir_count (){
    pushd /usr/lib/modules &>/dev/null
    dir_total=$(find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | wc -l)
    printf "\nDEBUG >>> Number of directories - %s" "$dir_total"
}


MAIN (){
    printf "\n"
    get_limit_value
    get_rpms_installed
    get_dir_count
    if [ "$dir_total" -gt "$limit_value" ]; then
        if [ "$dir_total" -gt "${#kernel_rpms[@]}" ]; then
            printf "\nThe number of directories (%s) exceeds number of installed kernels" "$dir_total"
            printf "\n>>> DOING DANGEROUS WORK HERE <<<"
        fi
    else
        printf "Total number of directories does not exceed installonly limit of dnf.conf"
    fi
    printf "\n"
}

MAIN