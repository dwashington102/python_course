#!/usr/bin/bash

<<'COMMENTS'
Script will run the commands necessary to upgrade Fedora to latest version.
example: Fedora 35 --> to Fedora 36

Enable the last 3 functions in MAIN() to force the upgrade to take place.

Exit Codes:
1 - Attempt to run script as non-root user
2 - Fedora is not installed

COMMENTS


is_fedora (){
    hostnamectl | grep Fedora
    if [ $? != "0" ]; then
        printf "\nFedora Not Installed"
        exit 2
    fi
    printf "\nFedora is installed"
}


check_uid (){
   if [ "$(id -u)" != "0" ]; then
	   printf "\nScript must be ran by root user...exiting"
	   exit 1
   fi
   printf "\nRunning script as root...continue"  
   sleep 10
}


preupdate_fedora (){
   dnf -y --verbose --refresh update
   dnf -y --verbose upgrade
}


reboot_fedora (){
    printf "\nWork to do here"
}


system_upgrade (){
    echo "Fedora Version: "
    read fedVer
    dnf -y system-upgrade download --releasever="$fedVer"
}


upgrade_reboot (){
    dnf -y system-upgrade reboot
}


MAIN () {
    printf "\nRunning this script WILL REBOOT this machine"
    check_uid
    is_fedora
    #preupdate_fedora
    #system_upgrade
    #upgrade_reboot
}

MAIN
