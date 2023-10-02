#!/usr/bin/bash

:<<"COMMENTS"
Script scrapes websites and pulls mp4 files from the links included.

URL:
https://www.route.com/video-123459/foobar

Equivalent: Shell Command
grep ${viewsrc} index+searchString.html  | awk -v http=$viewsrc -F'http' '{print $2}' | grep ${url} | awk -F'"' '{print "http"$1}'

Variables:
viewsrc="view-source:https"
url="x.com\/video-"


Sites: x_nx + searchString
"""
COMMENTS

MAIN (){
    func_set_colors
    func_start_time
    func_get_urls
    func_end_time
    func_download_files
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


func_start_time () {
    rawStartTime=$(date +%Y%m%d-%H:%M)
    printf "\n${green}${rawStartTime}\tBeginning process to download raw files...${normal}"
    printf "\n"
}


func_end_time () {
    printf "\n${green}==========Downloads Complete==========="
    rawEndTime=$(date +%Y%m%d-%H:%M)                                                                                                                                                                  
    printf "\n${green}${rawEndTime}${normal}"
    printf "\n"
}


func_get_urls () {
    # Function extracts urls from index.html, write to rawUrls file in $PWD, 
    # run wget againt each line in rawUrls saving to ./rawfiles dir,
    # for each file in rawfiles dir perform wget

    # Constant Variables
    export grep='grep --color=NEVER'
    export viewsrc='view-source:https'
    export url="x.com\/video-"

    printf "\n"
    grep ${viewsrc} index.html | awk -v http=$viewsrc -F'http' '{print $2}' | grep ${url} | awk -F'"' '{print "http"$1}' | sort -u > rawUrls

    printf "\nDownloading rawfiles to ./rawfiles directory"
    printf "\n"

    count=1
    for wgetUrl in $(cat rawUrls)
    do
        touch ./logs/get_urls.log
        wget --no-verbose --random-wait -a ./logs/get_urls.log -P ./rawfiles -O ./rawfiles/${count} ${wgetUrl}
        count=$((count+1))
    done
}


func_download_files (){
    pushd ./rawfiles &>/dev/null
    tot_dl_files=0
    tot_fail_dl=0
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in $(ls -1)
    do
        printf "\nDownloading video from file: \t ${finalMp4}\n"
        startTime=$(date +%Y%m%d-%H:%M)
        printf "\nStart Time:\t$startTime\tFilename: ${finalMp4}"
        grep -E setVideoUrl'(High|Low)' ${finalMp4} &>/dev/null
        if [[ "$?" == "0" ]]; then
            wget -a ../logs/download_files.log -P ../mp4 -O ../mp4/${tot_dl_files} $(grep -E setVideoUrl'(High|Low)' ${finalMp4} | awk -F"['']" '{print $2}')
            tot_dl_files=$((tot_dl_files+1))
        else
            tot_fail_dl=$((tot_fail_dl+1))
        fi
        endTime=$(date +%Y%m%d-%H:%M)
        printf "\nEnd Time:\t${endTime}\tFilename: ${finalMp4}"
     done
     printf "\nTotal Download Files: ${tot_dl_files}"
     printf "\nTotal Failed Downloads: ${tot_fail_dl}"
     popd
}


MAIN