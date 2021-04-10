#!/usr/bin/sh
# Version: 0.1.0
# Add comments!!!

# Script pulls mp4 files when index.html uses "<a href=/download" along with a baseUrl
# example:
# <a href="/download/videos/myfile">Title Here</a>

# Sites
# - d_af


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
    get_plugcontent
#    download_files
#    clean_up
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

get_plugcontent (){
#grep plugcontent index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' > php_output.txt
wget -a ./logs/get_plugcontent_rawfiles -P ./rawfiles `grep plugcontent index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}'` 


# Cat the file performing a wget on each entry in the file.  May need error checking here
#mkdir ./php
#for myPhp in `cat php_output.txt`
#    do
#        wget -P ./php ${myPhp}
#    done

# For each php  
for myFile in `ls -1 ./rawfiles | grep php`
    do
        wget -a ./logs/get_plugcontent_php -P ./mp4 `grep "source\ src=.*mp4" ./rawfiles/${myFile} | awk -F'[""]' '{print $2}'`
        #grep "source\ src=.*mp4" ./rawfiles/${myFile} | awk -F'[""]' '{print $2}' >> ./tmp/mylist.txt
    done

#for get_Download in `cat ./tmp/mylist.txt`
#    do
#        wget -P ./mp4 ${get_Download}
#        sleep 10
#    done
}

MAIN
exit 0