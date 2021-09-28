#!/bin/sh

# Script identifies blocking thread entries in the javacore*txt
# Usage: java_blocking.sh {javacore filename}


if [ "$1" == "" ]; then
    MAIN (){
        func_set_colors
        func_get_javacore
        func_get_pid
        func_bt
    }
else
    get_jcore=$1
    MAIN (){
        func_set_colors
        func_get_pid
        func_bt
    }
fi

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

func_get_javacore (){
    userChoice='abc'
    # Prompt user to input javacore filename
    while [ "${userChoice}" == 'abc' ]
    do
        printf "\nJavacore filename: "
        read get_jcore
    if [ -f "$get_jcore" ]; then
        printf "\nProcessing file: ${get_jcore}"
        userChoice='valid'
    else
        printf "\nUnable to find file: ${get_jcore}"
        userChoice='abc'
    fi
    done
}

func_get_pid () {
    jvmpid=`grep PROCESSID.*Process\ ID:  ${get_jcore} | awk -F':' '{print $2}' | awk -F' ' '{print $1}'`
        printf "${red}"
    printf "\nJVM PID Info: ${jvmpid}"
        printf "${normal}"
    printf "\n"
}

func_bt () {
    loopcount=1
    IFS=$'\n'
    blockingThread=`grep "THREADBLOCK.*Blocked on" ${get_jcore} | sort -u | awk -F"Owned by:" '{print $2}' | awk -F'[""]' '{print $2}'`
    for i in ${blockingThread[@]}
    do
        count_blocks=`grep -c ${i} ${get_jcore}`
        printf "${bold}${yellow}"
        printf "\n($loopcount) Blocking Thread: ${i} \n-----reported ${count_blocks} instances"
        printf "${normal}${boldoff}"
        printf "\n"
        printf "Java Stack Info:\n"
        grep -n -A10 THREADINFO.*${i} ${get_jcore} > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            grep -n -A10 THREADINFO.*${i} ${get_jcore}
        else
            printf "${red}"
            printf "\nTHREADINFO: NOT FOUND"
            printf "\n"
            printf "${normal}"
        fi
        sleep 5
    loopcount=$((loopcount + 1))
    done
}

MAIN
exit 0
