#!/bin/sh
# 
# Script checks the status of sshd service
# if the status is not "active" a restart sshd.service takes place 

# 2022-01-20 - Created func_delete_root_cron_logs to clean up older log files
# 2021-12 23 - Added func_check_uid to confirm the userid running the script is the root user
# 2021-09-27

func_delete_root_cron_logs (){
    (
    oldlogs=($(find . -name "cron_sshd*.log" -mtime +60 -print))
    printf "\nFiles to delete: ---- " 
    if [ ${#oldlogs[@]} -eq 0 ]; then
         printf "\nNo cron_sshd logs found older than 60 days" 
    else 
        for mylog in ${oldlogs[*]}
        do
            printf "\nFileName to delete: ${mylog}" 
            rm -f ${mylog}
            if [ $? == "0" ]; then
                printf "File ${mylog} deleted" 
            else
                printf "File ${mylog} failed to delete" 
            fi
        done
    fi
    printf "\n"
    ) >> /root/cron_sshd_running.log
}

# Function checks to confirm if the current userid is 0 (root).
# If the userid is not 0, print a message and exit
func_check_uid (){
    userId=$(id -u)
    if [ "$userId" == "0" ]; then
        timeStamp=`date +%Y%m%d_%H%M`
    else
        printf "\nUserID is non-root...exiting\n"
        exit 1
    fi
}

# Function checks if the sshd unit is running.
# If the sshd unit is not running, a restart is attempted by calling function func_restart_sshd
func_test_sshd (){
    get_status=`systemctl is-active sshd`
    if [ "$get_status" != 'active' ]; then  
        func_restart_sshd
    else
        echo "SSHD active at: ${timeStamp} "  > /root/cron_sshd_running.log
    fi
}

# Function writes the current status of sshd unit to a log
# Attempts to start sshd and writes results of the startup attempt to a log
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
    func_delete_root_cron_logs
}

MAIN
exit 0
