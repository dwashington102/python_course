#!/bin/bash

# Script is used to gather the PID associated with various desktop environments.


# Prereqs
# - Install a VM for each Desktop (Gnome, KDE, XFCE, Cinnamon)
# - Confirm the IP address for each VM and updated @VMHostList with correct IPs
# - From HOST machine ssh-copy-id public key to each VM


<< 'COMMENT'
Hosts and Desktop
35 - GNOME
36 - KDE
67 - XFCE
100 - Cinnamon
COMMENT


declare -a VMHostList=("35" "36" "67" "100")

for vmip in "${VMHostList[@]}"
    do
	    if [ "$vmip" == "35" ]; then
		    printf "\nGNOME Desktop: Process\n"
		    CMD="ps -e | grep -E '(^.* gnome-session.*$)'"
		    ssh washingd-dev@192.168.122.${vmip} ${CMD}
	    elif [ "$vmip" == "36" ]; then
		    printf "\nKDE Desktop: Process\n"
		    CMD="ps -e | grep -E '(^.* kded[[:digit:]]$)'"
		    ssh washingd-dev@192.168.122.${vmip} ${CMD}
	    elif [ "$vmip" == "67" ]; then
		    printf "\nXFCE Desktop: Process\n"
		    CMD="ps -e | grep -E '(^.* xfce[[:digit:]]-session$)'"
		    ssh washingd-dev@192.168.122.${vmip} ${CMD}
	    else
		    printf "\nCinnamon Desktop: Process\n"
		    CMD="ps -e | grep -E '(^.* cinnamon-sessio$)'"
		    ssh washingd-dev@192.168.122.${vmip} ${CMD}
            fi	
    done

exit 0


for vmip in "${VMHostList[@]}"
do
    cinn_check
    if [ $? != "0" ]; then
        xfce_check
	if [ $? != "0" ]; then
	    kde_check
	    if [ $? != "0" ]; then
	        gnome_check
	    fi
	fi
    else
        printf "\nCinnamon Desktop Detected"
    fi

cinn_check (){
	CMD="ps -e | grep -E '(^.* cinnamon-sessio$)'"
	ssh washingd-dev@192.168.122.${vmip} ${CMD}
	if [ $? == "0" ]; then
	    printf "\n192.168.122.${vmip} is running Cinnamon Desktop"
	else 
	    return 1
	fi
}

xfce_check (){
	CMD="ps -e | grep -E '(^.* xfce[[:digit:]]-session$)'"
	ssh washingd-dev@192.168.122.${vmip} ${CMD}
	if [ $? == "0" ]; then
	    printf "\n192.168.122.${vmip} is running Cinnamon Desktop"
	else 
	    return 1
	fi
}
