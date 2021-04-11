#!/usr/bin/env bash
# Version 0.1.0
#keywords:
# - x_vi

# Script scrapes and pulls mp4 files from websites where the video file is store in the following format:
#  html5player.setVideoUrlHigh('https://mywebsite.com/goatlaughing_a.mp4?')

# Usage

MAIN (){
    func_set_colors
    func_start_time
    func_get_urls
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
    printf "\n"
    grep div\ id=\"vide index.html |  awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' | sort -u > rawUrls
    printf "\nDownloading rawfiles to ./rawfiles directory..."
    printf "\n"
    for urlPath in `tail -2 rawUrls` 
    #for urlPath in `cat rawUrls`  <<<<-----DEBUG replace for stament above!!!!
    do
        getBaseUrl=`grep -m 1 slave index.html | awk -F'slave\"' '{print $2}' | awk -F'[""]' '{print $2}'`
        touch ./logs/get_urls.log
        wget -a ./logs/get_urls.log -P ./rawfiles ${getBaseUrl}${urlPath}
        sleep 2
    done

    file ./rawfiles/* | grep -m 1 HTML\ document
    if [ $? -ne 0 ]; then
        printf "\nNo rawfiles were downloaded"
        exit 3
    else
        printf "\nCompleted downloading rawfiles..."
        func_download_files
    fi
}


func_download_files (){
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in `ls -1 ./rawfiles/*`
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        grep setVideoUrlHigh ${finalMp4}
        if [ $? == 0 ]; then
            wget -a ./logs/download_files.log -P ./mp4 `grep setVideoUrlHigh ${finalMp4} | awk -F"setVideoUrlHigh" '{print $2}' | awk -F"['']" '{print $2}' | sort -u`
        else
            wget -a ./logs/download_files.log -P ./mp4 `grep setVideoUrl ${finalMp4} | awk -F"setVideoUrl" '{print $2}' | awk -F"['']" '{print $2}' | sort -u`
        fi
        endTime=`date +%Y%m%d-%H:%M`
        printf "\nEnd Time\t$endTime\tFilename: ${finalMp4} ":
        printf "\n======================="
        sleep 2
    done
    printf "\n"
}

MAIN
exit 0

