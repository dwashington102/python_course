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
    grep -Po '(?<=video_url:).*(?=, preview_url)' page_index


Sites:
c_69
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
    if [ -f ${agent_file} ]; then
        log_message "\tagent file found"
        WGET_AGENT=$(shuf -n 1 "$agent_file" | sed 's/^user_agent = //')
    fi
    log_message "\tDEBUG>>>user agent:($WGET_AGENT)"
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

    log_message "DEBUG>>> WGET_AGENT -> ${WGET_AGENT}"
    log_message "DEBUG>>> TOP_INDEX -> ${TOP_INDEX}"
    log_message "DEBUG>>> GETURL -> ${GETURL}"

    if [ -n ${wget_cmd_var} ]; then
        wget_cmd="wget --timeout=3 --no-check-certificate -a ./logs/get_index.log -O ${TOP_INDEX} ${GETURL}"
        wget_cmd_var=1
    else
        wget_cmd='wget --timeout=3 --user-agent="${WGET_AGENT}" --no-check-certificate -a ./logs/get_index.log -O ${TOP_INDEX} ${GETURL}'
        wget_cmd_var=2
    fi

    log_message "\tcmd var: ${wget_cmd_var}\n\t${wget_cmd}"
    ${wget_cmd}
    if [ ! -f ${TOP_INDEX} ] ; then
        printf "${red}${msg_results} FAILED ${normal}\n"
        exit 101
    fi

    printf "${green}${msg_results} SUCCESS ${normal}\n"
}

function func_pull_files (){
    log_message "${FUNCNAME[0]}()"
    target_urls="./rawfiles/urls.txt"
    search_str="video"
    p_index="page_index"
    
    # grep command to extract URLs from downloaded index
    grep --color=NEVER -Po '(?<=_blank").*(?=title)' ./${TOP_INDEX} \
    | grep --color=NEVER ${search_str} \
    | awk -F'[""]' '{print $2}'  >> ${target_urls}


    for url in $(tail -3 ${target_urls}); do
        func_set_useragent

        dts=$(date +"%Y%m%d_%H%M%S")

        printf "DEBUG>>>WGET_AGENT -> ${WGET_AGENT}\n"

        if [ -n "${WGET_AGENT}" ]; then
            wget_cmd="wget --timeout=3 --no-check-certificate -a ./logs/get_${p_index}.log -O ${p_index} ${url}"
            wget_cmd_var=1
        else
            wget_cmd='wget --timeout=3 --user-agent="${WGET_AGENT}" --no-check-certificate -a ./logs/get_${p_index}.log -O ${p_index} ${url}'
            wget_cmd_var=2
       fi

       # Pull mp4 using downloaded $p_index
       log_message "\twget_cmd_var: ${wget_cmd_var}"
       ${wget_cmd}

       if [ ! -f ${p_index} ]; then
           log_message "FAILED to created p_index file...exit 102"
           printf "FAILED to created p_index file...exit 102"
           exit 102
       fi

       result=$(grep -Po '(?<=video_url:).*(?=, preview_url)' ${p_index} | awk -F"['']" '{print $2}')
       printf "DEBUG>>> result -> ${result} saved to file: ./mp4/${dts}.mp4\n"
       wget --timeout=3 --wait=10 --random-wait --user-agent="${WGET_AGENT}" --no-check-certificate -a ./logs/get_mp4.log -O ./mp4/${dts}.mp4 ${result}
       sleep 2
    done
}

# main
RUNTIMELOG="./logs/runtime.log"
TOP_INDEX="index.html"

if [ "$1" == "" ]; then
    printf "Enter Target URL:\n"
    read GETURL
else
    GETURL="$1"
fi
MAIN
