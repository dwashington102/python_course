#!/usr/bin/bash

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
    dnf -y system-upgrade download --releasever=36
}

upgrade_reboot (){
    dnf -y system-upgrade reboot
}


MAIN () {
    check_uid
    preupdate_fedora
    system_upgrade
    upgrade_reboot
}

MAIN
