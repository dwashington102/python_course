#!/bin/bash                                                                                                                                                                                   
logfile="/tmp/bf_startcrowdstrike.log"

cleanup_log (){
if [ $(systemctl is-active falcon-sensor.service) == "active" ]; then
    rm -f "$logfile"
fi
}

get_service_status (){
    get_status=$(systemctl is-enabled falcon-sensor.service 2>/dev/null)
    if [ "$get_status" == "masked" ]; then
	    echo "falcon-sensor.service is masked"
        systemctl unmask falcon-sensor.service
        systemctl enable falcon-sensor.service --now
    elif [ "$get_status" == "disabled" ]; then
		echo "falcon-sensor.service is disabled"
        systemctl enable falcon-sensor.service --now
    elif [ "$get_status" == "enabled" ]; then
        systemctl start falcon-sensor.service
    else
        echo "falcon-sensor.service status is invalid"
    fi
}

get_rpm (){
    check_install=$(rpm -q falcon-sensor)
}

MAIN (){
    (
    get_rpm
    if [ -n "$check_install" ]; then
        get_service_status
		echo "falcon-sensor.service start rc=$?"
		cleanup_log
    else
	    echo "CrashPlan/Code42 installation NOT FOUND."
	fi
    printf "\n"
    ) >> $logfile
}

MAIN
printf "\n"
exit 0
