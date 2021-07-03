#!/usr/bin/env bash
: ' Purpose:  Script will check the status of NetworkMangager Service.
If the status 
The script is meant to be ran as a cronjob by the root user

Optional: If sshd is down an email alert should be sent to admins.

Version 1.0
Date: Sat 03 Jul 2021 05:01:14 AM CDT
'

tStamp=`date +%Y%m%d_%H%M`
logDir=/root/cronlogs/
logfile=${logDir}/${tStamp}_NetworkManager_DOWN.log

# get_status_sysd function: Used to confirm status of NetworkManager and restart NetworkManager when the server uses systemd
func_get_status_sysd () {
    # Variable set_rc_sysd=1 indicates the script expects the service to be down and will enter the loop to restart the service if VARIABLE get_rc_sysd=1
    set_rc_sysd=1
    systemctl status sshd | grep "Active:.*active.*running.*since" 
    get_rc_sysd=$?

    if [[ $get_rc_sysd == $set_rc_sysd ]]; then
        printf "\nNetwork Manager currently not running...restarting" > ${logfile}
        systemctl start NetworkManager
        start_rc_sysd=$?
        if [[ $start_rc_sysd == 0 ]]; then
            printf "\nNetworkManager successfully started"
        else
            printf "\nProblem encountered starting NetworkManager rc($start_rc_sysd)"
            printf "\nAs root start NetworkManager"
            printf "\ncommand: systemctl start NetworkManager"
            exit 3
    fi
}

# get_status_initd function: Used to confirm status of sshd and restart sshd when the server uses init
func_get_status_initd () {
    set_rc_initd=1
    service NetworkManager status | grep "Active:.*active.*running.*since"
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
}

function confirm_daemon() {
    # Function is used to confirm if the host server is using systemd or initd
    # A host server running systemd will show systemd as PID 1
    set_sysd_pid=1
    get_sysd_pid=`ps aux | grep -v grep | grep -m 1 systemd | awk '{print $2}'`
    if [[ $get_sysd_pid == $set_sysd_pid ]]; then
        # Calling function when server uses systemd
        get_status_sysd
    elif [[ $get_sys_pid != $set_sysd_pid ]]; then
        # Calling function when server uses initd
        get_status_initd
    else
        printf "Invalid result '$get_sys_pid' in function: ${FUNCNAME[0]}"
        printf "Unexpected results encountered...exiting now\n"
        exit 1
    fi
}

MAIN (){
    confirm_daemon
}


MAIN
exit 0
