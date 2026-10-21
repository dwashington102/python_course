#!/bin/bash

:<<'COMMENTS'
Script pulls mp4 file when page uses the following:
video_id: ....
...
...
video_url: 'https://videos.com/foobar.mp4', preview_url:...
...
...

url extracted using this grep statement:

Sites:
c_69
COMMENTS

MAIN (){
    prereqs
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    func_start_time
    func_pull_index
    func_end_time
}

# Functions
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


function prereqs (){
    if [ ! -f /usr/bin/wget ] || ! rpm -qi --quiet wget2; then
        printf "wget package is missing or not correctly installed...exit 101\n"
        exit 101
    fi

    if [ ! -d ./logs ]; then
        command mkdir ./logs
    fi

    if [ ! -d ./mp4 ]; then
        command mkdir ./mp4
    fi

    if [ ! -d ./rawfiles ]; then
        command mkdir ./rawfiles
    fi

}

function func_start_time () {
    rawStartTime=`date +%Y%m%d-%H:%M`
    printf "\n${green}${rawStartTime}\tBeginning process to download raw files...${normal}"
    printf "\n"
}

function func_end_time () {
    printf "\n${green}==========Downloads Complete==========="
    rawEndTime=`date +%Y%m%d-%H:%M`                                                                                                                                                                  
    printf "\n${green}${rawEndTime}${normal}"
    printf "\n"
}

function func_pull_index (){
    t_index="index"
    msg_results="Pulling of index: "

    if ! wget --no-check-certificate -a ./logs/get_index.log -O ${t_index} ${GETURL} ; then
        printf "${red}${msg_results} FAILED ${normal}\n"
        exit 101
    fi

    printf "${green}${msg_results} SUCCESS ${normal}\n"
}

function func_pull_files (){
    search_str="video"
    ar_urllist=$(grep -Po '(?<=_blank").*(?=title)' ./${t_index}) \
     | grep ${search_str} \
     | awk -F'[""]' '{print $2}'

    printf "DEBUG>>>list -> ${ar_urllist[*]}\n"
}

# main
prereqs
if [ "$1" == "" ]; then
    printf "Enter Target URL:\n"
    read GETURL
fi
MAIN