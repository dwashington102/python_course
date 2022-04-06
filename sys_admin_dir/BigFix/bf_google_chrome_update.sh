#!/bin/bash 

bf_temp_dir="/tmp/bf_upgrade-chrome"
logfile="$bf_temp_dir/bf_upgrade_chrome.log"

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
    ping -c2 -i2 dl.google.com &>/dev/null
    if [ "$?" != "0" ]; then
       if ["$(curl --connect-timeout 10 chrome.google.com)" != "0" ]; then
                echo "Unable to connect to Google repo...exiting"
        exit 1
       fi
        else
        echo "Network connection to google.com successful"
    fi
}

do_upgrade (){
    get_chrome_install=( $(rpm -qa --qf "%{NAME}\n" | grep google-chrome) )
    if [ ${#get_chrome_install[*]} -ne 0 ]; then
    echo "Downloading google-chrome packages"
    dnf upgrade --downloadonly ${get_chrome_install[*]} --downloaddir "$PWD" --repo google-chrome -y
    packages=$(find . -name '*.rpm' -exec basename {} \;)
    [ -n "$packages" ] && rpm -Fvh --test $packages || echo "No RPMs found...exiting ; exit 8"
    echo "Completed upgrade of google-chrome packages"
    else
    echo "No google-chrome packages installed"
    fi
}

MAIN (){
    [ -d "$bf_temp_dir" ] && 
    touch "$logfile"
    (
    echo "Starting upgrade of Google Chrome Packages"
    pushd "$bf_temp_dir" &>/dev/null
    check_network
    backup_rpmdb
    check_dnf
    do_upgrade
    echo "Script completed"
    ) > $logfile
}

MAIN
