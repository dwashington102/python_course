#!/bin/sh
# 
# Script checks the network connection sending a ping to www.yahoo.com
# if the ping fails a restart NetworkManager.service takes place 
# 2021-09-27

timeStamp=`date +%Y%m%d_%H%M`

func_test_network (){
    ping -i 1 -c3 www.yahoo.com
    get_rc=$?
    if [ $get_rc != 0 ]; then  
        func_restart_network
    else
        echo "Network Manager running at: ${timestamp} "  > /root/cron_network_running.log
    fi
}


func_restart_network (){
    systemctl restart NetworkManager.service
    if [ $? != 0 ]; then
        echo "NetworkManager Restart Failed: " > /root/cron_network_startup_failed_${timeStamp}.log
    else
	echo "NetworkManager Restarted. " > /root/cron_network_restarted_${timeStamp}.log
    fi
}

MAIN (){
    func_test_network
}

MAIN
exit 0
