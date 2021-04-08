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
    touch getUrls.txt && cat /dev/null > getUrls.txt
    get_getUrl
    get_downloadLinks
    gen_tmpFiles
    download_files
    clean_up
}


# Functions
# Gather the website URL from user input  
get_getUrl (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    # Pull index.html from URL
    wget ${getUrl}
}

get_downloadLinks (){
    grep --color=NEVER href=\"/download index.html | awk -F'[""]' '{print $2}' | sort -u >> getUrls.txt
}

gen_tmpFiles (){
    if [ -s getUrls.txt ]; then
        for urlPath in `cat getUrls.txt`
        do
            wget -P ./tmp ${getUrl}${urlPath}
        done
    else
        printf "\ngetUrls.txt file is empty...exiting"
        exit 1
    fi
}

download_files (){
    mkdir ./mp4
    for hDoc in `ls -1 ./tmp`
    do
        wget -P ./mp4 `grep HD\ Quality ./tmp/$hDoc | awk -F'[""]' '{print $2}'`
        sleep 10
    done
}


clean_up (){
    rm -rf index getUrls index* ./tmp
}

MAIN
exit 0



