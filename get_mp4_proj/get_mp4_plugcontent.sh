#!/usr/bin/env bash
# Version: 0.1.0
# Date: 4-10-2021
# Add comments!!!

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Keywords:
# - d_af


# Steps taken:
# 1) wget download rawfiles from index.html saving to ./rawfiles
# 2) wget mp4 files by extracting "source\ src=.*mp4" from rawfiles

MAIN (){
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    rawStartTime=`date +%Y%m%d-%H:%M`
    printf "\n${green}${rawStartTime}\tBeginning process to download raw files...${normal}"
    func_get_plugcontent_rawfiles
    printf "\n${green}==========Downloads Complete==========="
    rawEndTime=`date +%Y%m%d-%H:%M`
    printf "\n${green}${rawEndTime}${normal}"
    printf "\n"
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


func_get_plugcontent_rawfiles () {
printf "\n"
wget -a ./logs/get_plugcontent_rawfiles -P ./rawfiles `grep plugcontent index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' | sort -u`  
tot_files=0
# For each php  
for finalMp4 in `ls -1 ./rawfiles | grep php`
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        grep "source\ src=.*mp4" ./rawfiles/${finalMp4} 
        if [ $? == 0 ]; then
            wget -a ./logs/get_plugcontent_downloads -P ./mp4 `grep "source\ src=.*mp4" ./rawfiles/${finalMp4} | awk -F'[""]' '{print $2}'`
            tot_files=$((tot_files + 1))
        else
            printf "\nNo MP4 files found in ${finalMp4}"
            printf "\n"
        fi
        endTime=`date +%Y%m%d-%H:%M`
        printf "\nEnd Time\t$endTime\tFilename: ${finalMp4} "
        sleep 2
    done
    printf "\nTotal Files Downloaded: ${tot_files}"
    printf "\n"
}

MAIN
exit 0
