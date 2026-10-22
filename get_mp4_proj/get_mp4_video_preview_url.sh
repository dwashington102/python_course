#!/bin/bash

:<<'COMMENTS'
Script pulls mp4 file when page uses the following:
video_id: ....
...
...
video_url: 'https://videos.com/foobar.mp4', preview_url:...
...
...

grep statement used to extract url from top index:
    ar_urllist=$(grep --color=NEVER -Po '(?<=_blank").*(?=title)' ./${TOP_INDEX} \
    | grep --color=NEVER ${search_str} \
    | awk -F'[""]' '{print $2}' )

grep statement used to extract mp4 from page index:

Sites:
c_69
COMMENTS

MAIN (){
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    func_start_time
    func_pull_top_index

    agent_file="/root/static"

    # Select a random line from the file and strip the "user_agent = " string
    if [ -f ${agent_file} ]; then
        log_message "agent file found"
        WGET_AGENT=$(shuf -n 1 "$agent_file" | sed 's/^user_agent = //')
        log_message "user agent:($WGET_AGENT)"
    fi

    func_pull_files
    func_end_time
}

########################### Common Functions
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

function log_message(){
    local message
    message="$1"
    printf "%s: $message\n" "$(date --rfc-3339=seconds)" >> ${logfile}
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

########################### End Common Functions

function func_pull_top_index (){
    :<<DESCRIPTION
    - Pulls the index from a website
    - Extracts URLs included in the index file
    - For each URL -> confirm page index is available -> extract mp4 file
DESCRIPTION
    msg_results="Pulling of index: "

    if [ -n $WGET_AGENT ]; then
        wget_cmd="wget --no-check-certificate -a ./logs/get_index.log -O ${TOP_INDEX} ${GETURL}"
    else
        wget_cmd="wget --user-agent="$WGET_AGENT" --no-check-certificate -a ./logs/get_index.log -O ${TOP_INDEX} ${GETURL}"
    fi

    if ! $wget_cmd ; then
        printf "${red}${msg_results} FAILED ${normal}\n"
        exit 101
    fi

    printf "${green}${msg_results} SUCCESS ${normal}\n"
}

function func_pull_files (){
    search_str="video"
    ar_urllist=$(grep --color=NEVER -Po '(?<=_blank").*(?=title)' ./${TOP_INDEX} \
    | grep --color=NEVER ${search_str} \
    | awk -F'[""]' '{print $2}' )

    for $url in ${ar_urllist[@]}; do
        printf "$url\n"
        sleep 2
    done
}


# main
prereqs
if [ "$1" == "" ]; then
    printf "Enter Target URL:\n"
    read GETURL
fi

TOP_INDEX="index"
MAIN