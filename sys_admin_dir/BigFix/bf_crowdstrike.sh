#!/bin/bash

logfile=/tmp/bf_crowdstrike.txt
cat /dev/null > "$logfile"

get_service_status (){ 
    get_status=$(systemctl is-enabled falcon-sensor.service 2>/dev/null)
    if [ "$get_status" == "masked" ]; then
        systemctl unmask falcon-sensor.service
        systemctl enable falcon-sensor.service --now
    elif [ "$get_status" == "disabled" ]; then
        systemctl enable falcon-sensor.service --now
    elif [ "$get_status" == "enabled" ]; then
        printf "\nfalcon-sensor.service is enabled"
        systemctl start falcon-sensor.service
    else
        printf "\nfalcon-sensor.service status is invalid"
    fi
}

get_rpm (){
    check_install=$(rpm -qa falcon-sensor)
    if [ -z "$check_install" ]; then
        echo "falcon-sensor RPM not installed...performing installation"
        if [ -f /var/opt/BESClient/__BESData/CustomSite_IBM_ITCS_300_-28Linux-29/falcon-sensor-el8.run ]; then
	    /var/opt/BESClient/__BESData/CustomSite_IBM_ITCS_300_-28Linux-29/falcon-sensor-el8.run NONEU 
	    exit 0
	else
	    echo "falcon-sensor-el8.run NOT FOUND"
	    exit 2 
	fi

    fi
}

MAIN () {
    (
    get_rpm
    if [ "$?" == "0" ]; then
        get_service_status
    else
	    /var/opt/BESClient/__BESData/CustomSite_IBM_ITCS_300__-28Linux-29/falcon-sensor-el8.run NONEU
	exit 0
    fi
    printf "\n"
    ) >> $logfile
}

MAIN
printf "\n"
exit 0
