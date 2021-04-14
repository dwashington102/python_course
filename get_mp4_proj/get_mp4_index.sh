#!/usr/bin/env bash
# Version: 0.1.0

MAIN (){
    func_set_colors
    func_get_dir_userInput
    func_get_index_userInput
    func_get_index_rc
    func_test_index_rc
    func_clean_up
}

# Constant Variables
# tStamp variable is added to log files generated
tStamp=`date +%Y%m%d_%H%M`
export grep='grep --color=NEVER'

# Functions Section
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


func_create_dirs () {
        mkdir ./tmp > /dev/null 2>&1 
        mkdir ./mp4 > /dev/null 2>&1 
        mkdir ./rawfiles > /dev/null 2>&1 
        mkdir ./logs > /dev/null 2>&1 
}

func_get_dir_userInput () {
    printf "\n${bold}${yellow}WARNING WARNING WARNING WARNING WARNING"
    printf "\nThis script will remove ALL files in current directory\t ${cyan}${PWD}\n"
    choice='abc'
    while [ ${choice} = 'abc' ]
    do
        printf "\nDo you want to remove ALL files:\n${normal}"
        printf 'Type "yes" to DELETE ALL FILES IN CURRENT DIRECORY before adding directories created by script\n' 
        printf 'Type "n" to leave existing files and add directories created by script\n'
        printf 'Type "exit" to exit the script\n'
        printf '\n>>> '

        read choice
        IFS=$'\n'
        if [ ${choice} = 'yes' ]; then
            currentDir=$PWD
            printf "\nDEBUG >>> currentDir = ${currentDir}"
            if [ ${currentDir} = $HOME ]; then
                printf "${red}\nCurrent directory is $HOME"
                printf "${bold}\nScript should not be ran in $HOME${normal}"
                exit 1
            elif [ ${currentDir} == "/root" ]; then
                printf "${red}\nCurrent directory is /root"
                printf "${bold}\nScript should not be ran in /root${normal}"
                exit 1
            elif [ ${currentDir} == "/tmp"} ]; then
                printf "${red}\nCurrent directory is /root"
                printf "${bold}\nScript should not be ran in /root${normal}"
                exit 1
            else 
        printf "\n${bold}${red}About to delete directories...${normal}${boldoff}"
        sleep 60
        rm -rf *
        elif [ ${choice} = 'n' ]; then
            printf "Ok not removing existing files\n"
            ls -1 index.html > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                current_indexFile=`ls -1 index.html` 
                printf "\nExisting index.html file being renamed index.html_${tStamp}"
                printf "\n"
                mv index.html index.html_${tStamp}
            else
                printf "\nNo existing index.html files found in current directory"
            fi

        elif [ ${choice} = 'exit' ]; then
            printf "Exiting script\n"
            exit 0
        else
            printf "${bold}${red}Invalid entry...try again${normal}${boldoff}"
            choice='abc'
        fi
    done
}

func_get_index_userInput () {
    func_create_dirs
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    wget -a ./logs/get_getIndex.log ${getUrl}
    if [ $? -eq 0 ]; then
        ls -1 index.html > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            printf "\nDownload file name is not index.html"
            printf "\n"
            func_rename_index
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

func_rename_index (){
    list_indexFile=`file * | grep HTML\ document | awk -F':' '{print $1}'`
    printf "\nRenaming $list_indexFile to index.html"
    printf "\n"
    mv "${list_indexFile}" index.html
    printf "\n"
}

func_get_index_rc (){
    index_plugcontent=`grep plugcontent index.html | awk -F'a href=' '{print $2}' | awk -F'[""]' '{print $2}' | sort -u |  wc -l`
    index_div_video=`grep div\ id=\"video index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' | sort -u | wc -l`
    index_a_href=`grep href=\"/download index.html | awk -F'[""]' '{print $2}' | sort -u | wc -l`
}

func_test_index_rc (){
    #Calls get_mp4_plugcontent.sh
    if [ ${index_plugcontent} -gt 0 ]; then
        #printf "\nDEBUG >>> plugcontent"
        #sleep 10
        get_mp4_plugcontent.sh
        printf "\n"

    # Calls get_mp4_div_video.sh
    elif [ ${index_div_video} -gt 0 ]; then
        #printf "\nDEBUG >>> div_video"
        #sleep 10
        get_mp4_div_video.sh
        printf "\n"

    # Calls get_mp4_a_href.sh
    elif [ ${index_a_href} -gt 0 ]; then
        #printf "\nDEBUG >>> a_href"
        get_mp4_a_href.sh
        printf "\n"

    else
        printf "\nIndex type: NOT FOUND"
        printf "\n"
        exit 1
    fi
}

func_clean_up () {
    rm -rf ./rawfiles > /dev/null 2>&1
    rm -rf ./index.html > /dev/null 2>&1
    rm -rf ./tmp > /dev/null 2>&1
    rm -rf ./rawUrls > /dev/null 2>&1
}

MAIN
exit 0
