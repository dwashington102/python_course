#!/usr/bin/bash

<<'COMMENTS'
Script checks the status of installed BigFix Components

Exit Codes:
1 - No BigFix components found in /etc/init.d
COMMENTS

initDir='/etc/init.d'
declare -a besList=("")

func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    alloff=$(tput sgr0)
    reverse=$(tput rev)
    redfg=$(tput setaf 1)
    greenfg=$(tput setaf 2)
    yellowbg=$(tput setab 3)
    cyanbg=$(tput setab 6)
    normal=$(tput setaf 9)
}

get_sys_info (){
    printf "\n"
    #printf "   %s\n" "IP ADDR: $(curl --silent ifconfig.me)"
    #printf "   %s\n" "USER: $(echo $USER)"
    printf "%s\n" "HOSTNAME: $(hostname -f)"
    printf "%s\n" "DATE: $(date)"
    printf "%s\n" "UPTIME: $(uptime -p)"
    printf "%s\t\t" "CPU: $(cat /proc/cpuinfo | awk -F: '/model name/{print $2}' | head -1)"
    printf "%s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
    printf "%s\n" "KERNEL: $(uname -rms)"
    #printf "   %s\n" "PACKAGES: $(rpm -qa | wc -l)"
    #printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
    printf "\nFilesystem Usage:"
    printf "\nFilesystem                   Size  Used Avail Used Mounted on\n"
    df -h | command grep --extended-regexp "xvd|mapper"
    printf "\n"
}

get_components (){
    besList=( $(find . -maxdepth 1 -name "bes*" -type f -exec basename {} \;) )
    if [ ${#besList[@]} -eq 0 ]; then
    printf "No BigFix Components found in %s\n" "$initDir"
    exit 1
    fi
}

check_bigfix_status (){
    for besComp in "${besList[@]}"
    do
            status=$(service "$besComp" status )
            if [[ "$status" == *" is running."* ]]; then
               printf "\n%s is ${greenfg}running${alloff}" "$besComp"
            else
               printf "\n%s is ${redfg}DOWN${alloff}" "$besComp"
            fi
    done
}

check_db2_status (){
    pgrep db2sysc &>/dev/null
    if [[ "$?" == "0" ]]; then 
        printf "\n\nDB2 is ${greenfg}running${alloff}"
    else
        printf "\n\nDB2 is ${redfg}DOWN${alloff}"
    fi
}

MAIN (){
    func_set_colors
    pushd "$initDir" &>/dev/null
    printf "\n${bold}BigFix Environment Status${alloff}\n"
    get_components
    check_bigfix_status
    check_db2_status
    popd &>/dev/null
}
MAIN
printf "\n\n"
