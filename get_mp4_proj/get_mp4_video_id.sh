#!/usr/bin/env bash
# Version 0.1.0
#keywords:
# - c_uc

# Script scrapes and pulls mp4 files from websites where the video file is store in the following format:
#  ^video_id:.*video_url:*'https://mywebsite.com/goatlaughing_a.mp4', preview_url:*

# Usage

MAIN (){
    prereqs
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    func_start_time
    func_get_urls
    func_download_files
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

# Constant Variables
export grep='grep --color=NEVER'

func_start_time () {
    rawStartTime=`date +%Y%m%d-%H:%M`
    printf "\n${green}${rawStartTime}\tBeginning process to download raw files...${normal}"
    printf "\n"
}

func_end_time () {
    printf "\n${green}==========Downloads Complete==========="
    rawEndTime=`date +%Y%m%d-%H:%M`                                                                                                                                                                  
    printf "\n${green}${rawEndTime}${normal}"
    printf "\n"
}


func_get_urls () {
    printf "\n"
    command grep -E 'a target=.*title=' index.html | grep -vE '(gif|jpg)' | awk -F'[""]' '{print $4}' | command grep -E ^https: | sort -u > rawUrls
    printf "\nDownloading rawfiles to ./rawfiles directory..."
    printf "\n"
    if [ ! -s rawUrls ]; then
        printf "No URLs found in index.html...exit(103)"
        exit 103
    fi
}


func_download_files (){
    (
    tot_dl_files=0
    tot_fail_dl=0
    touch ./logs/get_urls.log   # Create log file
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"


    count=1
    IF=$'\n'
    for urlPath in $(cat rawUrls)
    do
        delay=$(echo $((1 + RANDOM % 5)))
        printf "DEBUG >>> urlPath -> ${urlPath}\n"
        sleep 2
        if ! wget --spider ${urlPath}; then
            printf "Unable to contact ${urlPath}...exit"
            break
        fi

        wget --random-wait -a ./logs/get_urls.log -P ./rawfiles -o ${count} ${urlPath}
        printf "DEBUG >>> delay -> $delay\n"
        sleep ${delay}
    done

    printf "Processing rawfiles...view download_files.log"
    for finalMp4 in $(ls -1 ./rawfiles/*)
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=$(date +%Y%m%d-%H:%M)
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        printf "DEBUG >>> grep statement:"
        command grep -m1 video_id ${finalMp4} | awk -F"video_url: " '{print $2}' | awk -F"['']" '{print $2}'
        getBaseUrl=$(command grep -m1 video_id ${finalMp4} | awk -F"video_url: " '{print $2}' | awk -F"['']" '{print $2}')
        printf "DEBUG >>> getBaseUrl --> ${getBaseUrl}\n"
        if [ ! -z ${getBaseUrl} ]; then
            wget --random-wait -a ./logs/download_files.log -P ./mp4 ${getBaseUrl} 
            tot_dl_files=$((tot_files + 1))
        fi
        endTime=`date +%Y%m%d-%H:%M`
        printf "\nEnd Time\t$endTime\tFilename: ${finalMp4} ":
        printf "\n======================="
        sleep ${delay}
    done
    printf "\nTotal Files Downloaded: ${tot_files}"
    printf "\n"
    ) &>./logs/download_files
}

MAIN
