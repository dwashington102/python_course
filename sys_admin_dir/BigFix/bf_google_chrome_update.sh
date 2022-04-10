#!/bin/bash


<< 'EXITCODES'
exit 1: Unable to ping/curl dl.google.com
exit 2: RPM db directory (/var/lib/rpm) has open files
exit 3: tar command used to backup RPM db failed
exit 4: Another dnf process is running
exit 8: After dnf download no RPM packages found in directory
EXITCODES

bf_temp_dir="/tmp/bf_linuxatibm"
logfile="$bf_temp_dir/bf_upgrade_chrome.log"
timeStamp=$(date +%Y%m%d_%H%M)

check_dnf (){
    IFS=$'\n'
    is_dnf_running=( $(ps -e | grep -E '(dnf|rpm)$') )
    if [ "${#is_dnf_running[@]}" -ne 0 ]; then
        echo "Another DNF process is running...exiting"
        printf "\nPIDs: \n%s" "${is_dnf_running[*]}"
        exit 4
    fi
}

backup_rpmdb () {
    IFS=$'\n'
    get_openfiles=( $(lsof -w +D /var/lib/rpm) )
    if [ "${#get_openfiles[@]}" -ne 0 ]; then
            echo "Directory /var/lib/rpm has open files...exiting"
            printf "\nOpen files: %s" "${get_openfiles[*]}"
        exit 2
    else
        echo "Backing up RPM database (/var/lib/rpm)"
        tar czvf /root/bf_rpmdatabase.tar.gz /var/lib/rpm
        if [ "$?" != 0 ]; then
            echo "Unable to backup RPM database"
            echo "Upgrade of Google Chrome will not continue...exiting"
            exit 3
        fi
    fi
}

check_network (){
    ping -c2 -i2 dl.google.com
    if [ "$?" != "0" ]; then
        if [ "$(curl -s --connect-timeout 10 dl.google.com)" != "0" ]; then
            echo "Unable to connect to Google repo...exiting"
            exit 1
        fi
    else
        echo "Network connection to dl.google.com repo successful"
    fi
}

do_upgrade (){
    get_chrome_install=( $(rpm -qa --qf "%{NAME}\n" | grep google-chrome) )
    if [ ${#get_chrome_install[*]} -ne 0 ]; then
        echo "Downloading google-chrome packages"
        dnf upgrade -v --downloadonly ${get_chrome_install[*]} --downloaddir "$PWD" --repo google-chrome -y
        pkg_names=$(find . -name '*.rpm' -exec basename {} \;) 
        if [ -n "$pkg_names" ]; then
            echo "Performing upgrade of google-chrome packages"
            rpm -Fvh --test "$pkg_names" 
            echo "Completed upgrade of google-chrome packages"
        else 
            echo "No RPMs found...exiting"
            exit 8
        fi
    else
        echo "No google-chrome packages installed"
    fi
}


MAIN (){
    [ ! -d $bf_temp_dir ] && mkdir -p "$bf_temp_dir" 
    touch "$logfile"
    (
    echo "Starting upgrade of Google Chrome Packages --- $timeStamp"
    pushd "$bf_temp_dir" &>/dev/null
    check_network
    backup_rpmdb
    check_dnf
    do_upgrade
    echo "Script completed"
    ) > $logfile
}

MAIN
