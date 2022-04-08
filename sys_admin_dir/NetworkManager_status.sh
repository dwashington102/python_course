#!/usr/bin/env bash
: ' Purpose:  Script will check the status of NetworkMangager Service.
If the status 
The script is meant to be ran as a cronjob by the root user

Optional: If sshd is down an email alert should be sent to admins.

Version 1.0
Date: Sat 03 Jul 2021 05:01:14 AM CDT
'

# 30-Mar-2022: Updated 

tStamp=`date +%Y%m%d_%H%M`
logDir=/root/cronlogs/
scriptName=`basename "$0"`
logfile=${logDir}/${tStamp}_NetworkManager_DOWN.log



# get_status_sysd function: Used to confirm status of NetworkManager and restart NetworkManager when the server uses systemd
func_get_status_sysd () {
    # Variable set_rc_sysd=1 indicates the script expects the service to be down and will enter the loop to restart the service if VARIABLE get_rc_sysd=1
    set_rc_sysd=1
    systemctl status NetworkManager.service | command grep "Active:.*active.*running.*since" 
    get_rc_sysd=$?

    if [[ $get_rc_sysd == $set_rc_sysd ]]; then
        printf "\nNetwork Manager (sysd) currently not running...restarting" > $logfile
        systemctl start NetworkManager.service
        start_rc_sysd=$?
        if [[ $start_rc_sysd == 0 ]]; then
            printf "\nNetworkManager (sysd) successfully started"
        else
            printf "\nProblem encountered starting NetworkManager (sysd) rc($start_rc_sysd)"
            printf "\nAs root start NetworkManager"
            printf "\ncommand: systemctl start NetworkManager"
            exit 3
        fi
    elif [[ $get_rc_sysd == 0 ]]; then
        printf "\nNetwork Manager is currently running" 
    else
        printf "ERROR encountered unable to retrieve NetworkManager status" >> $logfile
    fi
    printf "\n"
}

# get_status_initd function: Used to confirm status of sshd and restart sshd when the server uses init
func_get_status_initd () {
    set_rc_initd=1
    service NetworkManager status | command grep "Active:.*active.*running.*since"
    get_rc_initd=$?
    if [[ $get_rc_initd == $set_rc_initd ]]; then
        printf "NetworkManager currently not running...restarting\n" > ${logfile}
        service start NetworkManager
        start_rc_sysd=$?
        if [[ $start_rc_sysd == 0 ]]; then
            printf "NetworkManager successfully started\n"
        else
            printf "Problem encountered starting NetworkManager rc($start_rc_sysd)\n"
            printf "As root start NetworkManager\n"
            printf "command: service start NetworkManager"
            exit 3
        fi
    fi
}

MAIN (){
    if [ ! -d /root/cronlogs ]; then
    mkdir /root/cronlogs
    fi

    set_sysd_pid=1
    get_sysd_pid=$(ps -e | command grep -m 1 systemd | awk '{print $1}')
    if [ "$get_sysd_pid" =  "1" ]; then
        func_get_status_sysd
    else
        func_get_status_initd
    fi
    printf "\n"
}


MAIN
