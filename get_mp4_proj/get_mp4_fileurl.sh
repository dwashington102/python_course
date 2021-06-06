#!/usr/bin/env bash
# Version: 0.1.0
# Add comments!!!
# Testing

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Sites
# - m_ot

MAIN (){
    func_set_colors
    func_start_time
    func_get_urls
    func func_dl_mp4
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
    grep "a href.*https.*title=.*class=" index.html  | awk -F'[""]' '{print $2}' | sort -u > ./rawfiles/rawUrls
}

func_dl_mp4 () {
    if [ -s ./rawfiles/rawUrls ]; then
        printf "\nDownloading mp4 files."
        printf "\n"
        for urlPath in `cat ./rawfiles/rawUlrs`
        do
            IF=$'\n'
            wget -a ./logs/get_mp4_filename_${tStamp}.log -P ./mp4 $urlPath
            sleep 2
        done
        else
            printf "\nrawUrls file is empty...exiting"
            exit 1
    fi
}

MAIN
exit 0

