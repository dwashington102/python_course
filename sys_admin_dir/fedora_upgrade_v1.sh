#!/usr/bin/bash

<<'COMMENTS'
Script will run the commands necessary to upgrade Fedora to latest version.
The script should be ran as the root user

COMMENTS


check_uid (){
   printf "\nDEBUG:  $(id -u)\n"
   if [ "$(id -u)" == "0" ]; then
	   printf "\nRunning script as root...continue"  
   else
	   printf "\nScript must be ran by root user...exiting"
	   exit 1
   fi
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
    preupdate_fedora
    system_upgrade
    upgrade_reboot
}

MAIN
