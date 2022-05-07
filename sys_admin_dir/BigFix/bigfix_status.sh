#!/usr/bin/bash

<<'COMMENTS'
Script checks the status of installed BigFix Components
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
    yellowfg=$(tput setaf 3)
    cyanbg=$(tput setab 6)
    normal=$(tput setaf 9)
}

get_sys_info (){
printf "\n"                                                                                
printf "%s\n" "HOSTNAME: $(hostname -f)"
printf "%s\n" "DATE: $(date)"
printf "%s\n" "UPTIME: $(uptime -p)"
printf "%s\t\t" "CPU: $(cat /proc/cpuinfo | awk -F: '/model name/{print $2}' | head -1)"
printf "%s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
printf "%s\n" "KERNEL: $(uname -rms)"
#printf "   %s\n" "PACKAGES: $(rpm -qa | wc -l)"
#printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
printf "\nFilesystem Usage:"
printf "\nFilesystem                   Size  Used Avail Used Mounted on"
#df -h | command grep --extended-regexp "xvd|mapper"
mountPoints=$(df -h $(lsblk -o MOUNTPOINT | grep ^\/) | grep -v ^File)
printf "\n%s" "${mountPoints[@]}"
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
               printf "\n%-20s is %10s" "$besComp" "${greenfg}running${alloff}"
            else
               printf "\n%s is %10s${redfg}DOWN${alloff}" "$besComp"
            fi
    done
}

check_db2_status (){
    pgrep db2sysc &>/dev/null
    if [[ "$?" == "0" ]]; then 
        printf "\nDB2 is ${greenfg}running${alloff}"
    else
        printf "\nDB2 is ${redfg}DOWN${alloff}"
    fi
}

get_agent_version (){
    #Only works if script is running as root due to permission restriction on Agent log file
    printf "\n"
    logdate=$(date +%Y%m%d) 
    logdate_min1=$(date --date="yesterday" +%Y%m%d)
    check_log="/var/opt/bigfix/BESClient/__BESData/__Global/Logs/$logdate.log"
    check_log_min1="/var/opt/bigfix/BESClient/__BESData/__Global/Logs/$logdate_min1.log"
    if [ -f "$check_log" ]; then
        grep 'Client\ version.*built' "$check_log"  | awk -F'built' '{print $1}'
    else
        if [ -f "$check_log_min1" ]; then
            grep 'Client\ version.*built' "$check_log_min1"  | awk -F'built' '{print $1}'
        else
            printf "\nBES Client Version:  ${yellowfg}Unable to locate BESClient log${alloff}" 
        fi
    fi
}

get_bes_version (){
    printf "\n"
    if [ -f /var/log/BESInstall.log ]; then
        grep -E 'BES.*_64.*installed' /var/log/BESInstall.log  | awk -F"['']" '{print $2}' | awk -F"/" '{print $3}' | awk -F"-" '{print $1$2}'
    else
        printf "\n\n${yellowfg}Unable to get BES Components Version Info${alloff}"
    fi
}

get_db2_version (){
    db2ilistCmd=$(locate \/bin\/db2ilist | tail -1)
    if [ "${#db2ilistCmd}" == "0" ]; then
        printf "\nUnable to locate db2ilist command"
    else 
        get_db2InstanceList=( $($db2ilistCmd) )
        for db2InstanceName in ${get_db2InstanceList[@]}
        do
            if [[ $(id -u) == "0" ]]; then
            db2VersionFull=$(runuser -l "$db2InstanceName" -c "db2level" | grep ^Informational\ tokens)
            db2Version=$(echo "$db2VersionFull" | awk -F'[""]' '{print $2}')
            printf "\nDB2 Version  - %+30s" "$db2Version"
            printf "\nDB2 Instance - %+30s" "$db2InstanceName"
            elif [[ $(id -n -u) == "$db2InstanceName" ]]; then
            db2VersionFull=$(db2level | grep ^Informational\ tokens) 
            db2Version=$(echo "$db2VersionFull" | awk -F'[""]' '{print $2}')
            printf "\nDB2 Version  - %+30s" "$db2Version"
            printf "\nDB2 Instance - %+30s" "$db2InstanceName"
            else
            printf "\nDB2 Version  - %+30s" "Unable to run db2level command"
            printf "\nDB2 Instance - %+30s" "$db2InstanceName"
            fi
        done
    fi
    printf "\n"
}


MAIN (){
    func_set_colors
    get_sys_info
    pushd "$initDir" &>/dev/null
    printf "\n${bold}BigFix Environment Status:${alloff}"
    get_components
    check_bigfix_status 
    printf "\n\nBigFix Software Version Info:"
    get_bes_version
    [[ $(id -u) == "0" ]]  && get_agent_version || printf "${yellowfg}BES Client Version: Unable to get BESClient Version${alloff}\n" 
    printf "\nDB2 Status:"
    check_db2_status
    #[[ $(id -u) == "0" ]] && get_db2_version || printf "\n${yellowfg}Unable to get DB2 Instance Information and Version${alloff}\n"
    get_db2_version || printf "\n${yellowfg}Unable to get DB2 Instance Information and Version${alloff}\n"
    popd &>/dev/null
}
MAIN
printf "\n\n"
