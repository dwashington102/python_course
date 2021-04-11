#!/usr/bin/sh 
# Version: 0.1.0
# Add comments!!!

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Sites
# - wapbo


# Steps taken:

MAIN (){
    func_set_colors
    func_start_time
    func_get_urls
    func_gen_tmpFiles
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
    baseUrl=`grep "og:url" index.html | awk -F'og:url.*content' '{print $2}' | awk -F'[""]' '{print $2}' | awk -F".com" '{print $1".com"}'`
    wget -q --spider ${baseUrl} > /dev/null 2>&1
    if [ $? -ne 0 ];then
        printf "Unable to reach ${baseUrl}\n"
        printf "exiting....\n"
        exit 4
    else
        printf "Successfully reached ${baseUrl}\n"
    fi
}

func_gen_tmpFiles (){
    if [ -s rawUrls ]; then
    for urlPath in `cat rawUrls`
        do
            IFS=$'\n'
            wget -a ./logs/gen_tmpFiles -P ./tmp ${baseUrl}${urlPath}
	    if [ $? == 0 ]; then
                printf "\n${green}wget rc=$?${normal}:\t${baseUrl}${urlPath}"
                sleep 2
	    else
		printf "\n${red}wget failed for ${baseUrl}${urlPath}${normal}"
                sleep 2
        fi
        done
    else
        printf "\nrawUrls file is empty...exiting"
        exit 1
    fi
}

func_download_files (){
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in `ls -1 ./tmp`
    do
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        wget  -a ./logs/download_files -P ./mp4 `grep HD\ Quality ./tmp/$finalMp4 | awk -F'[""]' '{print $2}'`
        endTime=`date +%Y%m%d-%H:%M`
        printf "\nEnd Time\t$endTime\tFilename: ${finalMp4} ":
        printf "\n======================="
        sleep 2
    done
}

MAIN
exit 0
