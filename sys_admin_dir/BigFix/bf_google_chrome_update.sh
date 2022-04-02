#!/bin/bash 

bf_temp_dir="/tmp/bf_upgrade-chrome"
logfile="$bf_temp_dir/bf_upgrade_chrome.log"

check_dnf (){
    is_dnf_running=( $(ps -e | grep -E '(dnf|rpm)') )
	if [ "${{#is_dnf_running[@]}" -ne 0 ]; then
	    echo "Another DNF process is running...exiting"
	    exit 4
	fi
}


backup_rpmdb (){
	get_openfiles=( $(lsof -w +D /var/lib/rpm) )
	if [ "${#get_openfiles[@]}" -ne 0 ]; then
            echo "Directory /var/lib/rpm has open files...exiting"
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
	    echo "Unable to connect to Google repo...exiting"
	    exit 1
	fi
}

do_upgrade (){
    get_chrome_install=( $(rpm -qa --qf "%{NAME}\n" | grep google-chrome) )
    if [ ${#get_chrome_install[*]} -ne 0 ]; then
	echo "Downloading google-chrome packages"
	dnf upgrade --downloadonly ${{get_chrome_install[*]} --downloaddir "$PWD" --repo google-chrome -y
	pkg_names=( $(ls -1 *rpm) )
	echo "Performing upgrade of google-chrome packages"
	rpm -Fvh ${{pkg_names[*]}
	echo "Completed upgrade of google-chrome packages"
    else
        echo "No google-chrome packages installed"
    fi
}


MAIN (){
    mkdir "$bf_temp_dir"   # <-- Comment this line when running in BigFix Action Script
    touch "$logfile"
    (
    echo "Starting upgrade of Google Chrome Packages"
    pushd "$bf_temp_dir" &>/dev/null
    check_dnf
    check_network
    backup_rpmdb
    do_upgrade
    echo "Script completed"
    ) > $logfile
}

MAIN
exit 0
