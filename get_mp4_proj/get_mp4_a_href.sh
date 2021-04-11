#!/usr/bin/sh 
# Version: 0.1.0
# Add comments!!!

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Sites
# - wapbo


# Steps taken:
# 1) Prompt user for URL
# 2) wget URL --> downloads index.html
# 3) set baseUrl equal to user provided URL
# 4) grep download links from index.html save each link to a text file
# 5) wget for each link in the text file saving each file to ./tmp directory
# 6) for each file in ./tmp directory grep "HD\ Quality" and wget contents

MAIN (){
    set_colors
    create_dirs
    get_getIndex
    get_urls
    gen_tmpFiles
    download_files
    clean_up
}


# Functions
set_colors () {
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

create_dirs () {
    printf "\n${bold}${yellow}WARNING WARNING WARNING WARNING WARNING"
    printf "\nThis script will remove ALL files in current directory\t ${cyan}${PWD}\n"
    choice='abc'
    while [ ${choice} = 'abc' ]
    do
        printf "\nDo you want to remove ALL files (y/n):\t${normal}"
        read choice
        IFS=$'\n'
        if [ ${choice} = 'y' ]; then
            rm -rf *
            mkdir ./tmp
            mkdir ./mp4
            mkdir ./rawfiles
            mkdir ./logs
            export grep='grep --color=NEVER'
        elif [ ${choice} = 'n' ]; then
            printf "Ok not removing existing files\n"
        else
            printf "${bold}${red}Invalid entry...try again${normal}${boldoff}"
            choice='abc'
        fi
    done
}

get_getIndex (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    wget -a ./logs/get_getIndex.log ${getUrl}
    if [ $? -eq 0 ]; then
        ls -1 index.html > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            printf "\nDownload file name is not index.html"
            printf "\n"
            rename_index
        else
            printf "\nDownload file name is index.html...beginning to process"
            printf "\n"
        fi
    else
        printf "\nwget failed to pull index file"
        printf "\nConfirm the correct URL...exiting."
        printf "\n"
        exit 148
    fi
}

rename_index (){
    list_indexFile=`file * | grep HTML\ document | awk -F':' '{print $1}'`
    printf "\nRenaming $list_indexFile to index.html"
    printf "\n"
    mv "${list_indexFile}" index.html
    printf "\n"
}



get_urls (){
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

gen_tmpFiles (){
    if [ -s rawUrls ]; then
    for urlPath in `cat rawUrls`
        do
            IFS=$'\n'
            wget -a ./logs/gen_tmpFiles -P ./tmp ${baseUrl}${urlPath}
	    if [ $? == 0 ]; then
                printf "\n${green}wget rc=$?${normal}"
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

download_files (){
    for hDoc in `ls -1 ./tmp`
    do
        wget  -a ./logs/download_files -P ./mp4 `grep HD\ Quality ./tmp/$hDoc | awk -F'[""]' '{print $2}'`
        sleep 2
    done
}


clean_up (){
    rm -rf ./tmp
    rm -rf ./index.html
    rm -rf ./rawfiles
    rm -rf ./rawUrls
}

MAIN
exit 0



