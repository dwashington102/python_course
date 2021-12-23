#!/bin/sh
# 
# Script checks the status of sshd service
# if the status is not "active" a restart sshd.service takes place 

# 2021-12 23 - Added func_check_uid to confirm the userid running the script is the root user
# 2021-09-27


func_check_uid (){
    userId=$(id -u)
    if [ $userId == 0 ]; then
        timeStamp=`date +%Y%m%d_%H%M`
    else
        printf "\nUserID is non-root...exiting\n"
        exit 1
    fi
}

func_test_sshd (){
    get_status=`systemctl is-active sshd`
    if [ $get_status != 'active' ]; then  
        func_restart_sshd
    else
        echo "SSHD active at: ${timeStamp} "  > /root/cron_sshd_running.log
    fi
}


func_restart_sshd (){
    echo "SSHD ${get_status}" > /root/cron_sshd_down_${timeStamp}.log
    systemctl restart sshd.service
    if [ $? != 0 ]; then
        echo "SSHD Restart Failed" >> /root/cron_sshd_down_${timeStamp}.log
    else
	echo "SSHD Restarted. " >> /root/cron_sshd_down_${timeStamp}.log
    fi
}

MAIN (){
    func_check_uid
    func_test_sshd
}

MAIN
exit 0