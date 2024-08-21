#!/usr/bin/env bash
# Version: 0.1.0
# Add comments!!!
# Testing

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/videos/myfile">

# Sites
# - x_ra

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
    grep '<a href="/video' index.html| awk -F"a href=" '{print $2}' | awk -F'[""]' '{print $2}' | grep --color=never --extended-regexp ^"/video" | sort -u > rawUrls
    baseUrl=$(grep -m 1 "var base_url" index.html | awk -F'[""]' '{print $2}') 
    wget -q --no-check-certificate --spider ${baseUrl} &>/dev/null
    if [ $? -ne 0 ];then
        printf "Unable to reach ${baseUrl}\n"
        printf "exiting....\n"
        exit 101
    else
        printf "Successfully reached ${baseUrl}\n"
    fi
}

func_gen_rawFiles (){
    if [ -s rawUrls ]; then
    printf "\nGenerating files in ./rawfiles"
    printf "\n"
    for urlPath in $(cat rawUrls)
        do
            IFS=$'\n'
            #printf "\nDEBUG urlPath: %s" "${urlPath}"
            #printf "\nDEBUG baseUrl: %s" "${baseUrl}"
            sleep 10
            wget --verbose --no-check-certificate -a ./logs/gen_tmpFiles -P ./rawfiles ${baseUrl}${urlPath}
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
    tot_files=0
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in $(ls -1 ./rawfiles)
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        wget  --no-check-certificate -a ./logs/download_files -P ./mp4 `grep -m 1 source\ src= ./rawfiles/$finalMp4 | awk -F'source src=' '{print $2}' | awk -F'[""]' '{print $2}'`
        if [ $? == 0 ]; then
            endTime=`date +%Y%m%d-%H:%M`
            printf "\nEnd Time\t$endTime\tFilename: ${finalMp4}"
            tot_files=$((tot_files+1))
        else
            endTime=`date +%Y%m%d-%H:%M`
            printf "\n${red}End Time\t$endTime\tFilename: ${finalMp4}${normal}"
        fi
        printf "\n======================="
        sleep 2
    done
    printf "\nTotal Files Downloaded: ${tot_files}"
}

MAIN
exit 0
