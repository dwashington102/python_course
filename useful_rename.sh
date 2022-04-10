#!/bin/bash

bf_temp_dir="/tmp/bf_linuxatibm"
logfile="$bf_temp_dir/bf_upgrade_chrome.log"
bf_downloads="/var/opt/BESClient/__BESData/__Global/__Cache/Downloads"


do_upgrade (){
    get_chrome_install=( $(rpm -qa --qf "%{NAME}\n" | grep google-chrome) )
    if [ ${#get_chrome_install[*]} -ne 0 ]; then
        echo "Downloading google-chrome packages"
        dnf upgrade --downloadonly ${get_chrome_install[*]} --downloaddir "$PWD" --repo google-chrome -y
        pkg_names=$(find . -name '*.rpm' -exec basename {} \;) 
        if [ -n "$pkg_names" ]; then
            echo "Performing upgrade of google-chrome packages"
            rpm -Fvh --test "$pkg_names" 
            echo "Completed upgrade of google-chrome packages"
        else 
            echo "No RPMs found...exiting"
            return 8
        fi
    else
        echo "No google-chrome packages installed"
    fi
}


func_rename_rpm (){
    pushd $bf_downloads
    IF=$'\n'
    get_rpms=( $(file * | grep --extended-regexp ": RPM" | awk -F":" '{print $1}') )
    for rename_rpm in ${get_rpms[*]}
        do
           mv $rename_rpm $(file $rename_rpm | awk '{print $NF".rpm"}')
        done
}



MAIN (){
    [ ! -d $bf_temp_dir ] && mkdir -p "$bf_temp_dir"
    touch "$logfile"
    (
    echo "Starting upgrade of Google Chrome Packages"
    pushd "$bf_temp_dir" &>/dev/null
    #check_network
    #backup_rpmdb
    #check_dnf
    #do_upgrade
    func_rename_rpm
    echo "Script completed"
    ) > $logfile
}

MAIN
