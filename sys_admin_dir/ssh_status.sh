#!/bin/sh
# Purpose:  Script will check the status of sshd.
# The script is meant to be ran as a cronjob by the root user

# Optional: If sshd is down an email alert should be sent to admins.

# Date: 01-05-2021
# Version 1.0


# get_status_sysd function: Used to confirm status of sshd and restart sshd when the server uses systemd
function get_status_sysd () {
    #set_rc_sysd=1 indicates the script expects the sshd process to be down and will enter the loop to restart sshd if get_rc_sysd == 1
    # The get_rc_sysd confirms if sshd is down
    set_rc_sysd=1
    systemctl status sshd | grep "Active:.*active.*running.*"
    get_rc_sysd=$?

    if [[ $get_rc_sysd == $set_rc_sysd ]]; then
        printf "SSH (sysd) currently not running...restarting\n"
        systemctl start sshd
        start_rc_sysd=$?
        if [[ $start_rc_sysd == 0 ]]; then
            printf "SSH (sysd) successfully started\n"
        else
            printf "Problem encountered starting sshd (sysd) rc($start_rc_sysd)\n"
            printf "As root start sshd\n"
            printf "systemctl start sshd"
            exit 3
        fi
    elif [[ $get_rc_sysd == 0 ]]; then
        printf "SSH (sysd) currently running.\n"
    else
        printf "Invalid result '$get_rc_sysd' in function: ${FUNCNAME[0]}"
        printf "Unexpected results encountered...exiting now\n"
        exit 1
    fi

}

# get_status_initd function: Used to confirm status of sshd and restart sshd when the server uses init
function get_status_initd () {
    #set_rc_initd=1 indicates the script expects the sshd process to be down and will enter the loop to restart sshd if get_rc_initd == 1
    set_rc_initd=1
    service sshd status | grep "Active:.*active.*running"
    get_rc_initd=$?
    if [[ $get_rc_initd == $set_rc_initd ]]; then
        printf "SSH currently not running...restarting\n"
        service sshd start
        start_rc_initd=$?
        if [[ $start_rc_initd == 0 ]]; then
            printf "SSH successfully started\n"
        else    
            printf "Problem encountered starting sshd rc($start_rc_sysd)\n"
            printf "As root start sshd\n"
            printf "servcie start sshd"
            exit 3
        fi
    elif [[ $get_rc_initd == 0 ]]; then
        printf "SSH currently running.\n"
    else
        printf "Invalid result '$get_rc_initd' in function: ${FUNCNAME[0]}"
        printf "Unexpected results encountered...exiting now\n"
        exit 1
    fi

}

function confirm_daemon() {
    # Function is used to confirm if the host server is using daemon systemd or initd daemon
    # A host server running systemd will show systemd as PID 1
    set_sysd_pid=1
    get_sysd_pid=`ps aux | grep -v grep | grep -m 1 systemd | awk '{print $2}'`
    if [[ $get_sysd_pid == $set_sysd_pid ]]; then
        # Calling function when server uses systemd
        printf "\nDEBUG >>> calling sysd()"
        sleep 10
        get_status_sysd
    elif [[ $get_sys_pid != $set_sysd_pid ]]; then
        # Calling function when server uses initd
        printf "\nDEBUG >>> calling initd()"
        sleep 10
        get_status_initd
    else
        printf "Invalid result '$get_sys_pid' in function: ${FUNCNAME[0]}"
        printf "Unexpected results encountered...exiting now\n"
        exit 1
    fi
}

function MAIN (){
    confirm_daemon
}


# Where the magic happens
MAIN
exit 