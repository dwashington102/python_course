#!/usr/bin/env bash
# Version: 0.1.0
# Add comments!!!
# Testing

# Script pulls mp4 files when files contain the text "__fileurl.*http"
# example:
# __fileurl = 'https://cdn5-videos.com/videos/JELLYROLL.mp4'

# Sites
# - m_ot

MAIN (){
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

# Constant Variables
export grep='grep --color=NEVER'

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
    printf "\nExtracting URLs to ./tmp/rawUrls file..."
    printf "\n"
    grep "a href.*https.*title=.*class=" index.html  | awk -F'[""]' '{print $2}' | sort -u > ./tmp/rawUrls
    if [ -s ./tmp/rawUrls ]; then
        func_gen_rawFiles
    else
        printf "\nIndex.html does not contain URLS"
        exit 3
    fi
}


func_gen_rawFiles (){
    printf "\nGenerating files in ./rawfiles"
    printf "\n"
    for urlPath in $(cat ./tmp/rawUrls)
        do
            IFS=$'\n'
            wget --no-check-certificate -a ./logs/gen_tmpFiles -P ./rawfiles ${urlPath}
	        if [ $? == 0 ]; then
                printf "${green}.${normal}"
                sleep 2
	        else
                printf "${red}.${normal}"
                sleep 2
            fi
        done
}

func_download_files (){
    tot_dl_files=0
    tot_fail_dl=0
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in $(ls -1 ./rawfiles)
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=$(date +%Y%m%d-%H:%M)
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        wget  --no-check-certificate -a ./logs/download_files -P ./mp4 $(grep "__fileurl.*http.*mp4" ./rawfiles/$finalMp4 | awk -F"['']" '{print $2}')
        if [ $? == 0 ]; then
                endTime=$(date +%Y%m%d-%H:%M)
            printf "\nEnd Time\t$endTime\tFilename: ${finalMp4}"
            tot_dl_files=$((tot_dl_files + 1))
        else
            endTime=$(date +%Y%m%d-%H:%M)
            printf "\n${red}End Time\t$endTime\tFilename: ${finalMp4}${normal}"
            tot_fail_dl=$((tot_fail_dl + 1))
        fi
        printf "\n======================="
        sleep 2
    done
    printf "\nTotal Files Downloaded: ${tot_dl_files}"
    printf "\nTotal Fail Downloaded: ${tot_fail_dl}"
    printf "\n"
}

MAIN
exit 0

