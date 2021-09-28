#!/bin/sh
# Script confirms if there are more than 3 java processes running on lab servers.
# If there are less than 3 java processes running on the server it indicates
# the BAW environment is not currently running

alias grep='grep --color=NEVER'

MAIN () {
    func_set_colors
    func_log_env
    func_check_uptime
}

func_log_env () {
    env > ./env.txt
}

func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    boldoff=$(tput sgr0)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
    boldoff=$(tput sgr0)
}

func_check_uptime () {
    for myvm in `cat ~/LAB_ENV/lab_hosts.txt | grep ^9 | awk '{print $1}'`
    do
    	printf "\n${bold}-----------\/\/------------${boldoff}"
    	printf "\nIP Address:\t $myvm\n"
        # Sending a test ping to the lab machine 
    	/usr/bin/ping -c 1 ${myvm}  > /dev/null 2>&1
    	if [[ $? == 0 ]]; then
    	    #ssh root@${myvm} 'uptime && printf "Running JVMs:\t" && ps aux | grep java | grep -v grep | wc -l && printf "\n"'
    	    java_pid=`ssh root@${myvm} 'ps aux | grep java | grep -v grep | wc -l'`
            if [[ ${java_pid} -lt 3 ]]; then
    	        printf "${red}Number of java processes ${java_pid} running on ${myvm}${normal}\n"
		printf "Uptime: "
    	        ssh root@${myvm} 'uptime'
            else
                printf "${green}Number of java processes ${java_pid} running on ${myvm}${normal}\n"
		printf "Uptime: "
    	        ssh root@${myvm} 'uptime'
	    fi
        else
            printf "${red}"
            printf "\nping to ${myvm} FAILED!"
            printf "${normal}"
        fi
    	printf "${bold}\n-----------/\/\------------${boldoff}"
    done
    sleep 2
    printf "\n"
}

MAIN
exit 0
