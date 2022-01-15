#!/bin/sh


MAIN () {
    func_set_colors
    func_yumUpdate
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

func_yumUpdate () {
    for myvm in `tail -5 ~/YAML/hosts | command grep ^9`
    do
    	printf "\n${bold}-----------\/\/------------${boldoff}"
    	printf "\nIP Address:\t $myvm\n"
    	printf "Hostname:\t `nslookup $myvm | awk -F" = " '{print $2}'`"
        printf "\n"
        # Sending a test ping to the lab machine
    	command ping -c 1 ${myvm}  > /dev/null 2>&1
    	if [[ $? == 0 ]]; then
    	    ssh root@${myvm} 'yum update -y'
        else
    	    printf "\nUnable to reach $myvm"
        fi
    	printf "${bold}\n-----------/\/\------------${boldoff}"
        sleep 2
    done
    printf "\n"
}

MAIN
exit 0