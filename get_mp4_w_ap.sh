#!/usr/bin/env sh
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
    create_dirs
    get_getIndex
    get_urls
    gen_tmpFiles
    download_files
    #clean_up
}


# Functions
create_dirs () {
    echo -e "\033[33;5m WARNING WARNING WARNING WARNING WARNING\033[0m"
    printf "This script will remove ALL files in current directory\t "
    echo  "\033[33;5m ($PWD) \033[0m"
    printf "\nDo you want to remove ALL files (y/n):\t"
    read choice
    IFS=$'\n'
    if [ ${choice} = 'y' ]; then
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

get_getIndex (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    wget -a ./logs/get_getIndex.log ${getUrl}
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
    printf "\n"
}



get_urls (){
    grep --color=NEVER href=\"/download index.html | awk -F'[""]' '{print $2}' | sort -u > rawUrls
    baseUrl=`grep "og:url" index.html | awk -F'og:url.*content' '{print $2}' | awk -F'[""]' '{print $2}'`
}

gen_tmpFiles (){
    if [ -s rawUrls ]; then
    for urlPath in `cat rawUrls`
        do
            IFS=$'\n'
            wget -a ./logs/gen_tmpFiles -P ./tmp ${baseUrl}${urlPath}
            printf "\nwget rc=$?"
            sleep 2
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



