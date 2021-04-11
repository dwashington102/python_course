#!/usr/bin/env bash
# Version 0.1.0
#keywords:
# - x_vi

# Script scrapes and pulls mp4 files from websites where the video file is store in the following format:
#  html5player.setVideoUrlHigh('https://mywebsite.com/goatlaughing_a.mp4?')

# Usage
# 1) Prompt user for the URL
# 2) using wget pull "index.html" file from the URL
# 3) Pull the RAWFILE names from index.html and extract video

tStamp=`date +%Y%m%d_%H%M`
get_ext () {
    printf "Input Ext.:\t"
    read ext_type

}

MAIN (){
    create_dirs
    get_getIndex
    get_urls
    clean_up
    printf "\n"
}


create_dirs () {
    echo -e "\033[33;5m WARNING WARNING WARNING WARNING WARNING\033[0m"
    printf "This script will remove ALL files in current directory ($PWD): \n"
    printf "Do you want to remove ALL files (y/n):\t"
    read choice
    IFS=$'\n'
    if [ ${choice} == 'y' ]; then
        rm -rf *
        mkdir ./tmp
        mkdir ./mp4
        mkdir ./rawfiles
        mkdir ./logs
        export grep='grep --color=NEVER'
    else
        printf "Ok not removing existing files\n"
    fi
}

# Gather the website URL from user input  
get_getIndex (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    wget -o ./logs/get_getIndex.log ${getUrl}
    ls -1 index.html > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf "\nDownload file name is not index.html"
        printf "\n"
        rename_index
    else
        printf "\nDownload file name is index.html...beginning to process"
        printf "\n"
    fi
}

rename_index (){
    list_indexFile=`file * | grep HTML\ document | awk -F':' '{print $1}'`
    printf "\nRenaming $list_indexFile to index.html"
    printf "\n"
    mv "${list_indexFile}" index.html
}


get_urls (){
    grep div\ id=\"vide index.html |  awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' | sort -u > rawUrls
    printf "\nDownloading rawfiles to ./rawfiles directory..."
    for urlPath in `cat rawUrls` 
    do
        getBaseUrl=`grep -m 1 slave index.html | awk -F'slave\"' '{print $2}' | awk -F'[""]' '{print $2}'`
        touch ./logs/get_urls.log
        wget -a ./logs/get_urls.log -P ./rawfiles ${getBaseUrl}${urlPath}
        sleep 2
    done

    file ./rawfiles/* | grep -m 1 HTML\ document
    if [ $? -ne 0 ]; then
        printf "\nNo files were downloaded"
        exit 3
    else
        printf "\nCompleted downloading rawfiles..."
        download_files
    fi
}


download_files (){
    printf "\nBeginning process to extract video file information from rawfiles..."
    for finalMp4 in `ls -1 ./rawfiles/*`
    do
        printf "\nDownloading video from file:\t ${finalMp4}\n"
        grep setVideoUrlHigh ${finalMp4}
        if [ $? == 0 ]; then
            wget -a ./logs/download_files.log -P ./mp4 `grep setVideoUrlHigh ${finalMp4} | awk -F"setVideoUrlHigh" '{print $2}' | awk -F"['']" '{print $2}' | sort -u`
        else
            wget -a ./logs/download_files.log -P ./mp4 `grep setVideoUrl ${finalMp4} | awk -F"setVideoUrl" '{print $2}' | awk -F"['']" '{print $2}' | sort -u`
        fi
        printf "Completed download:\n"
        date +%Y%m%d
        printf "\n======================="
        sleep 2
    done
    printf "\n"
    echo -e "\033[32;5m ========== Downloads Complete =========== \033[0m"
}

clean_up (){
    rm -rf ./tmp
    rm -rf ./index.html
    rm -rf ./rawfiles
    rm -rf ./rawUrls
}

MAIN
exit 0

