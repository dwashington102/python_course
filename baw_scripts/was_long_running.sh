#!/usr/bin/env bash
# Date: 5-14-2021

# Script extracts long running threads from the SystemOut log and then checks if the thread id ever completes


func_getSystemOut () {
    printf "\nEnter Filename:\t"
    read sysOutFile
}

func_fileCheck (){
    if [ -f ${sysOutFile} ]; then
        printf "\nFile ${sysOutFile} exists"
    else
        printf "\nFile ${sysOutFile} does not exists"
        exit 2
    fi
}


func_get_hungThreads () {
    hungThreadList=`grep WSVR0605W ${sysOutFile} | awk -F'[()]' '{print $2}'`
    for hungThread in ${hungThreadList[@]}
    do
        printf "\nThreadId: ${hungThread}"
        printf "\n"
        func_check_WSVR0606W
    done

}

func_check_WSVR0606W () {
    thread_complete=`grep WSVR0606W ${sysOutFile} | grep ${hungThread}`
    if [ $? = 0 ]; then
        printf "Completed\n"
        printf "${thread_complete}\n"
        sleep 2
    else
        printf "NOT COMPLETED\n"
        sleep 2
    fi
}

MAIN (){
    func_getSystemOut
    func_fileCheck
    func_get_hungThreads
    printf "\n"
}


MAIN

exit 0
