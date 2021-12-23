#!/bin/sh
# 
# Script checks the network connection sending a ping to www.yahoo.com
# if the ping fails a restart NetworkManager.service takes place 


func_check_uid (){
    userId=$(id -u)
    if [ $userId == 0 ]; then
        timeStamp=$(date +%Y%m%d_%H%M)
    else
        printf "\nUserID is non-root...exiting\n"
        exit 1
    fi
}

func_test_network (){
    ping -i 1 -c3 8.8.8.8
    get_rc=$?
    if [ $get_rc != 0 ]; then  
        func_restart_network
    else
        echo "Network Manager running at: ${timeStamp} "  > /root/cron_network_running.log
    fi
}


func_restart_network (){
    echo "Network Manager restart attemted at: ${timeStamp}" > /root/cron_network_down_${timeStamp}.log
    systemctl is-active NetworkManager.service >> /root/cron_network_down_${timeStamp}.log
    systemctl restart NetworkManager.service
    if [ $? != 0 ]; then
        echo "NetworkManager Restart Failed: " >> /root/cron_network_down_${timeStamp}.log
    else
	echo "NetworkManager Restarted. " >> /root/cron_network_down_${timeStamp}.log
    fi
}

func_remove_logs_gt_10day (){
    CRON_LOG_DIR='/root'
    cd ${CRON_LOG_DIR}
    get_logs=$(find . -mtime +10 -name 'cron_network*.log' | wc -l)
    if [ ${get_logs} -gt 0 ]; then
        find . -mtime +10 -name 'cron_network*.log' | xargs rm -f $1
    fi

}

MAIN (){
    func_check_uid
    func_test_network
    func_remove_logs_gt_10day
}

MAIN
exit 0
