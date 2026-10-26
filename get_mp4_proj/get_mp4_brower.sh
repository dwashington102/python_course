#!/bin/bash

:<<'COMMENTS'

To extract the URL path to the mp4 file the grep command with -Po flags
is useful


Sites:
b_ad
COMMENTS

MAIN (){
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    func_start_time
    func_create_dirs
    prereqs
    func_set_useragent 
    func_pull_top_index 
    func_pull_file
}

########################## Common Functions
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

function func_create_dirs (){
:<<DESCRIPTION

DESCRIPTION
    d_names=("logs" "mp4" "rawfiles")
    for dirname in ${d_names[@]}; do 
        if [ -d ${dirname} ]; then
            rm -rf ${dirname}
        fi
        mkdir ${dirname}
    done

    if [ ! -d ./logs ]; then
        printf "Unable to created logs directory...exit(102)"
        exit 102
    fi

    touch $RUNTIMELOG
    log_message "${FUNCNAME[0]}()"
}

function prereqs (){
    log_message "${FUNCNAME[0]}()"
    if [ ! -f /usr/bin/wget ] || ! rpm -qi --quiet wget2; then
        printf "wget package is missing or not correctly installed...exit 101\n"
        exit 101
    fi
}

function log_message(){
    local message
    message="$1"
    printf "%s: $message\n" "$(date --rfc-3339=seconds)" >> ${RUNTIMELOG}
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
function func_set_useragent (){
:<<DESCRIPTION
    - Random setting of wget user Agent using contents of static file
    - Select a random line from the file and strip the "user_agent = " string

    Format of statis file:
    user_agent = Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0
    user_agent = Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
DESCRIPTION

    log_message "${FUNCNAME[0]}()"
    agent_file="/root/static/static_WGETRC"
    WGET_AGENT=""
    if [ -f ${agent_file} ]; then
        log_message "\tagent file found"
        WGET_AGENT=$(shuf -n 1 "$agent_file" | sed 's/^user_agent = //')
    fi
}

function func_pull_top_index (){
:<<DESCRIPTION
    - Pulls the index from a website
    - Extracts URLs included in the index file
    - For each URL -> confirm page index is available -> extract mp4 file
DESCRIPTION

    log_message "${FUNCNAME[0]}()"
    msg_results="Pulling of index: "
    wget_cmd_var=0

    if [ -z "${WGET_AGENT}" ]; then
        wget_cmd="wget --timeout=3 --no-check-certificate -a ./logs/get_index.log -O ${TOP_INDEX} ${GETURL}"
        wget_cmd_var=1
    else
        wget_cmd=(
            --timeout=3 
            --user-agent="${WGET_AGENT}"
            --no-check-certificate 
            -a "./logs/get_index.log"
            -O "${TOP_INDEX}"
            ${GETURL}
        )
        wget_cmd_var=2
    fi

    log_message "\tCalling wget_cmd"
    if [ $wget_cmd_var == "1" ]; then
        ${wget_cmd}
    else
        wget "${wget_cmd[@]}"
    fi

    log_message "\twget_cmd rc: ($?)"

    if [ ! -s ${TOP_INDEX} ] ; then
        printf "${red}${msg_results} FAILED ${normal}\n"
        exit 101
    fi

    printf "${green}${msg_results} SUCCESS ${normal}\n"
}

function func_pull_file (){
:<<DESCRIPTION
DESCRIPTION
    log_message "${FUNCNAME[0]}()"
    sp_count=1
    ar_urllist=$(grep --color=NEVER -Po '(?<=id=post-28381><a href=).*?(?=title)' ${TOP_INDEX})
    for url in ${ar_urllist[@]}; do
        if [[ $sp_count -le 5 ]]; then
            dts=$(date +"%Y%m%d_%H%M%S")
            func_set_useragent
            log_message "\tDEBUG>>> url -> ${url}\t" 
            log_message "\tCalling browser"
            brave-browser --headless --dump-dom ${url} > ./rawfiles/${dts}.dom
            sleep 2
            results_mp4=$(grep -Po '(?<=video class).*videos.*?(?=></video)' ./rawfiles/${dts}.dom | awk -F'[""]' '{print $12}')
            log_message "\tDEBUG>>>Extracted mp4 file: results_mp4 --> ${results_mp4}"
            wget -O ./mp4/${dts}.mp4 -a ./logs/get_mp4.log ${results_mp4}
            # log_message "\tbrowser rc: ($?)"
            # log_message "\tDEBUG>>>Extracting mp4 file"
            # mp4_url=$(grep --color=NEVER -Po '(?<=video class).*?(?="></video)' ./rawfiles/${dts.html})
            # log_message "\tDEBUG>>> mp4_url -> ${mp4_url}" ; exit 0
            # wget -O ./mp4/${dts}.mp4 -a ./logs/get_mp4.log $mp4_url
            sp_count=$((sp_count + 1))
        fi
    done
}


# main
RUNTIMELOG="./logs/runtime.log"
TOP_INDEX="index.html"

if [ "$1" == "" ]; then
    printf "Enter Target URL:\t"
    read GETURL
else
    GETURL="$1"
fi
MAIN