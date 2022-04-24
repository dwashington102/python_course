#!/usr/bin/bash

:<<'WARNING'
The purpose of this script is to remove outdated/unwanted kernels from /usr/lib/modules
There is no way this script should be run in Production without full filesystem backups
being available.

This is what happens when you wake up at 4am and realize "hey /usr/lib/modules
has a lot more than 3 subdirectories".

Steps to take before running this script:
1) Confirm system can be restored from backup OR YOU may end up rebuilding
2) Confirm "installonly_limit" setting in the /etc/dnf/dnf.conf is being used

Details of the script:
1 - Gather the max. number of kernels setting from dnf.conf
2 - Gather the total number of "kernel-core" rpms installed
3 - Count number to subdirectories in /usr/lib/module
4 - Check if the total number of subdirectories is greater than installonly limit set in /etc/dnf/dnf.conf
    - If yes --> Check if total number of subdirectores is greater than # of kernel-core rpms installed
    - If yes --> Loop through dir_total[@] and delete subdirectories ONLY if the subdirectory name DOES NOT
    match kernel names included in kernel_rpms[@]

EXIT CODES:
        1: Non-root user attempted to run script
WARNING

# Standard function to enable colors for console output
func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}


# Gather the max. number of kernels setting from dnf.conf
get_limit_value (){
    limit_value=$(grep installonly /etc/dnf/dnf.conf | awk -F"=" '{print $2}')
    printf "\ndnf.conf max. number of kernels - %s" "$limit_value"
}

# Gather the total  number of "kernel-core" rpms installed
get_rpms_installed (){
    kernel_rpms=( $(rpm -qa | grep ^kernel-core | awk -F"core-" '{print $2}') )
    printf "\nNumber of kernel RPMS installed - %s" "${#kernel_rpms[@]}"
}

# Gather the total number of subdirectories in /usr/lib/module
get_dir_count (){
    pushd /usr/lib/modules &>/dev/null
    dir_total=( $(find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \;) )
    printf "\nTotal Number of directories - %s" "${#dir_total[@]}"
}

func_check_uid (){
        if [[ $(id -u) != 0 ]]; then
            printf "Script must be ran as root...exit (1)\n"
            exit 1
        fi
}


MAIN (){
    func_check_uid
    func_set_colors
    IFS=$'\n'
    printf "\n"
    get_limit_value
    get_rpms_installed
    get_dir_count

    if [[ "${#dir_total[@]}" -gt "$limit_value" ]]; then
        if [[ "${#dir_total[@]}" -gt "${#kernel_rpms[@]}" ]]; then
            printf "\n"
            printf "\nThe number of directories (%s) exceeds number of installed kernels" "${#dir_total[@]}"
            printf "\n\n${bold}${red}${reverse}${blink}>>> DOING DANGEROUS WORK HERE <<<${offall}"
            printf "\n"
            deleteCount=0
            saveCount=0

            declare -a deleteDirs=()
            declare -a savedDirs=()

            for dirName in "${dir_total[@]}"
            do
                echo "${kernel_rpms[*]}" | grep "$dirName"  1>/dev/null
                if [[ "$?" -ne 0 ]]; then
                    deleteCount=$((deleteCount +1 ))
                    deleteDirs+=($dirName)
                    #Uncomment following 2 lines to delete the unwanted directories
                    #printf "\nDelete directory: %s\n" "$dirName"
                    #rm --verbose -I --recursive "$dirName"
                else 
                    saveCount=$((saveCount +1))
                    savedDirs+=($dirName)
                fi
            done
        fi
        printf "\n"
        printf "\nTotal Directories to delete:"
        printf "\n%s" "${deleteDirs[*]}" | sort
        printf "\n"
        printf "\nTotal Directories to save:"
        printf "\n%s" "${savedDirs[*]}" | sort
        printf "\n"
    else
        printf "\nTotal number of directories does not exceed installonly limit of dnf.conf"
        printf "\n"

    fi

    printf "\n"
    printf "\nInstalled RPMS:"
    printf "\n%s" "${kernel_rpms[*]}" | sort
    printf "\n"
}

MAIN