#!/usr/bin/env bash
# Version: 0.1.0
# Add comments!!!
# Testing 

# Script pulls mp4 files when index.html uses "<a href=.*php.*title" 
# example:

# Sites
# - t_er


MAIN (){
    if [ -f /usr/bin/tput ]; then
        func_set_colors
    fi
    func_start_time
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

func_gen_rawFiles (){
    phplist=( $(command grep -E ^'<a href=.*php.*title' index.html | awk -F'[""]' '{print $2}' | sort -u | grep -E 'php$' | sort -u) )
    if [[ ${#phplist[@]} -gt 0 ]]; then
        printf "\nGenerating files in ./rawfiles"
        printf "\n"
        for entry in ${phplist[@]}
            do
                wget --no-check-certificate -a ./logs/gen_tmpFiles -P ./rawfiles ${baseUrl}${urlPath}
                if wget --spider --force-html ${entry} --quiet; then
                    wget --random-wait -a ./logs/gen_tmpFiles -P ./rawfiles ${entry}
                    delay=$(echo $((1 + RANDOM % 5)))
	                if [ $? == 0 ]; then
                        printf "${green}.${normal}"
                        sleep ${delay}
	               else
	    	           #printf "\n${red}wget failed for ${baseUrl}${urlPath}${normal}"
                       printf "${red}.${normal}"
                       sleep ${delay}
                  fi
              fi
            done
    else
        printf "\nUnable to extract php urls...exit(1)\n"
        exit 1
    fi
}

func_download_files (){
    tot_dl_files=0
    tot_fail_dl=0
    count=1
    printf "Console logging stopped. Logging to ./logs/download_files\n"
    (
    printf "\n${green}Beginning process to extract video file information from rawfiles...${normal}"
    for finalMp4 in $(command ls -1 ./rawfiles)
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        startTime=`date +%Y%m%d-%H:%M`
        printf "\nStart Time\t$startTime\tFilename: ${finalMp4} "
        mp4url=$(command grep 'source src=.*mp4.*type=.*mp4' ./rawfiles/${finalMp4} | awk -F'[""]' '{print $2}' | sort -u)
        delay=$(echo $((1 + RANDOM % 5)))
        sleep ${delay}
        if wget -O ./mp4/${count} --random-wait "${mp4url}"; then
            endTime=`date +%Y%m%d-%H:%M`
            printf "\n${green}End Time\t$endTime\tFailed Filename: ${finalMp4}${normal}"
            tot_dl_files=$((tot_dl_files + 1))
        else
            endTime=`date +%Y%m%d-%H:%M`
            printf "\n${red}End Time\t$endTime\tFailed Filename: ${finalMp4}${normal}"
            tot_fail_dl=$((tot_fail_dl + 1))
        fi
        printf "\n======================="
        count=$((count+1))
        sleep ${delay}
    done
    printf "\nTotal Files Downloaded: ${tot_dl_files}"
    printf "\nTotal Failed Downloaded: ${tot_fail_dl}"
    printf "\n"
    ) &>./logs/download_files
}

MAIN
exit 0
