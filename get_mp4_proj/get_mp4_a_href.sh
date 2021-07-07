#!/usr/bin/env bash
# Version: 0.1.0
# Add comments!!!
# Testing 

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Sites
# - wapbo

: '
Sat 03 Jul 2021 01:01:46 PM CDT
Updated wget statement used to download final file including
--no-check-certificate
'

# Steps taken:

MAIN (){
    func_set_colors
    func_start_time
    func_get_urls
    func_gen_rawFiles
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

func_get_urls (){
    grep --color=NEVER href=\"/download index.html | awk -F'[""]' '{print $2}' | sort -u > rawUrls
    baseUrl=`grep "og:url" index.html | awk -F'og:url.*content' '{print $2}' | awk -F'[""]' '{print $2}' | awk -F".com" '{print $1".com"}' | sort -u`
    wget -q --no-check-certificate --spider ${baseUrl} > /dev/null 2>&1
    if [ $? -ne 0 ];then
        printf "Unable to reach ${baseUrl}\n"
        printf "exiting....[get_mp4_a_href]\n"
        exit 101
    else
        printf "Successfully reached ${baseUrl}\n"
    fi
}

func_gen_rawFiles (){
    if [ -s rawUrls ]; then
    printf "\nGenerating files in ./rawfiles"
    printf "\n"
    for urlPath in `cat rawUrls`
        do
            IFS=$'\n'
            wget --no-check-certificate -a ./logs/gen_tmpFiles -P ./rawfiles ${baseUrl}${urlPath}
	    if [ $? == 0 ]; then
            #printf "\n${green}wget rc=$?${normal}:\t${baseUrl}${urlPath}"
            printf "${green}.${normal}"
            sleep 2
	    else
		    #printf "\n${red}wget failed for ${baseUrl}${urlPath}${normal}"
            printf "${red}.${normal}"
            sleep 2
        fi
        done
    else
        printf "\nrawUrls file is empty...exiting"
        exit 1
    fi
}

func_download_files (){
    tot_dl_files=0
    tot_fail_dl=0
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in `ls -1 ./rawfiles`
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        wget --no-check-certificate  -a ./logs/download_files -P ./mp4 `grep HD\ Quality ./rawfiles/$finalMp4 | awk -F'[""]' '{print $2}'`
        if [ $? == 0 ]; then
            endTime=`date +%Y%m%d-%H:%M`
            printf "\nEnd Time\t$endTime\tFilename: ${finalMp4}"
            tot_dl_files=$((tot_dl_files + 1))
        else
            endTime=`date +%Y%m%d-%H:%M`
            printf "\n${red}End Time\t$endTime\tFailed Filename: ${finalMp4}${normal}"
            tot_fail_dl=$((tot_fail_dl + 1))
        fi
        printf "\n======================="
        sleep 2
    done
    printf "\nTotal Files Downloaded: ${tot_dl_files}"
    printf "\nTotal Failed Downloaded: ${tot_fail_dl}"
    printf "\n"
}

MAIN
exit 0
