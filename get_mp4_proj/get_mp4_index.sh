#!/usr/bin/env bash
# Version: 0.1.6
# 2021-06-29: Updated to accept URL via CLI


# Constant Variables
# tStamp variable is added to log files generated
tStamp=$(date +%Y%m%d_%H%M)
export grep='grep --color=NEVER'
export tmpDir='/tmp'
export rootDir='/root'
export homeDir=$HOME

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


function prereqs() {
    if [[ ! -f /usr/bin/wget ]]; then
        printf "Required command(s) not found...exit(101)\n"
        printf "\t- wget\n"
        exit 101
    fi
}

func_start () {
    func_create_dirs
    wget --no-check-certificate -a ./logs/get_getIndex.log ${getUrl} -O index.html
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


func_create_dirs () {
        # Function creates the directories where downloads, logs, and files are stored
        mkdir ./tmp &>/dev/null
        mkdir ./mp4 &>/dev/null
        mkdir ./rawfiles &>/dev/null
        mkdir ./logs &>/dev/null
}


func_get_dir_userInput () {
    printf "\n${bold}${yellow}WARNING WARNING WARNING WARNING WARNING"
    printf "\nThis script will remove ALL files in current directory\t ${cyan}${PWD}\n"
    choice='abc'
    while [ ${choice} = 'abc' ]
    do
        printf "\nDo you want to remove ALL files:\n${normal}"
        printf 'Type "yes" to DELETE ALL FILES IN CURRENT DIRECTORY before adding directories created by script\n' 
        printf 'Type "n" to leave existing files and add directories created by script\n'
        printf 'Type "exit" to exit the script\n'
        printf '\n>>> '

        read choice
        IFS=$'\n'
        if [ ${choice} = 'yes' ]; then
            currentDir=$PWD
            if [ ${currentDir} = ${homeDir} ]; then
                printf "${red}\nCurrent directory is $HOME"
                printf "${bold}\nScript cannot be ran in $HOME${normal}"
                printf "\n"
                exit 13
            elif [ ${currentDir} == ${rootDir} ]; then
                printf "${red}\nCurrent directory is /root"
                printf "${bold}\nScript cannot be ran in /root${normal}"
                printf "\n"
                exit 13
            elif [ ${currentDir} == ${tmpDir} ]; then
                printf "${red}\nCurrent directory is /tmp"
                printf "${bold}\nScript cannot be ran in /tmp${normal}"
                printf "\n"
                exit 13
            else 
                printf "\n${bold}${red}About to delete directories...${normal}${boldoff}"
                printf "\n"
                sleep 5
                rm -rf *
            fi
        elif [ ${choice} = 'n' ]; then
            printf "Ok not removing existing files\n"
            ls -1 index.html &>/dev/null
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
    wget --no-check-certificate -a ./logs/get_getIndex.log ${getUrl} -O index.html
    if [ $? -eq 0 ]; then
        ls -1 index.html &>/dev/null
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
    list_indexFile=`file * | grep -E 'HTML document' | awk -F':' '{print $1}'`
    printf "\nRenaming $list_indexFile to index.html"
    printf "\n"
    mv "${list_indexFile}" index.html
    printf "\n"
}

func_get_index_rc (){
    index_plugcontent=`grep plugcontent index.html | awk -F'a href=' '{print $2}' | awk -F'[""]' '{print $2}' | sort -u |  wc -l`
    index_div_video=$(grep -E 'div id="video' index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' | sort -u | wc -l)
    index_a_href=$(grep -E 'href="/download' index.html | awk -F'[""]' '{print $2}' | sort -u | wc -l)
    index_a_href_vid=$(grep '[[:digit:]] views.*<a href="/video' index.html | awk -F'[""]' '{print $2}' | sort -u | wc -l)
    index_a_href_fileurl=`grep 'a href=.*http.*title=.*class=' index.html | awk -F'[""]' '{print $2}' | sort -u | wc -l`
    index_a_href_vid_title=$(grep 'a href=.*title=' index.html | awk -F'[""]' '{print $2}' | sort -u | wc -l)
    index_view_source=$(grep view-source:https index.html | awk -F'view-source:https' '{print $2}' | grep -E "x.com/video-" | awk -F'"' '{print "http"$1}' |  sort -u | wc -l)
    index_php_source=$(command grep -E ^'<a href=.*php.*title' index.html | awk -F'[""]' '{print $2}' | sort -u | grep -E 'php$' | sort -u | wc -l)
}

func_test_index_rc (){
    # Site: x_ra 
    if [ ${index_a_href_vid} -gt 0 ]; then
        echo "Calling get_mp4_a_href_vid.sh" > ./logs/get_mp4_index.log
        get_mp4_a_href_vid.sh
        printf "\n"

    # Site: d_af
    elif [ ${index_plugcontent} -gt 0 ]; then
        echo "Calling get_mp4_plugcontent.sh" > ./logs/get_mp4_index.log
        get_mp4_plugcontent.sh
        printf "\n"

    # Site: x_vi
    elif [ ${index_div_video} -gt 0 ]; then
        echo "Calling get_mp4_div_video.sh" > ./logs/get_mp4_index.log
        get_mp4_div_video.sh
        printf "\n"

    # Site: w_ap
    elif [ ${index_a_href} -gt 0 ]; then
        echo "Calling get_mp4_a_href.sh" > ./logs/get_mp4_index.log
        get_mp4_a_href.sh
        printf "\n"

    # Site: m_ot
    elif [ ${index_a_href_fileurl} -gt 0 ]; then
        echo "Calling get_mp4_fileurl.sh" > ./logs/get_mp4_index.log
        get_mp4_fileurl.sh
        printf "\n"

    # Site: s_ho
    elif [ ${index_a_href_vid_title} -gt 0 ]; then
        echo "Calling get_mp4_a_href_vid_title.sh" > ./logs/get_mp4_index.log
        get_mp4_a_href_vid_title.sh
        printf "\n"

    # Site x_nx + search 
    elif [ ${index_view_source} -gt 0 ]; then
        echo "Calling get_mp4_view-source.sh" > ./logs/get_mp4_index.log
        get_mp4_view-source.sh
        printf "\n"

    # Sites: t_er
    elif [ ${#index_php_source[@]} -gt 0 ]; then
        echo "Calling get_mp4_php_source.sh" > ./logs/get_mp4_index.log
        get_mp4_php.sh
        printf "\n"
    else
        printf "\nIndex type: NOT FOUND" > ./logs/get_mp4_index.log
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

# Begin MAIN function
prereqs
if [ "$1" == "" ]; then
    MAIN (){
        if [[ -f /usr/bin/tput ]]; then
            func_set_colors
        fi
        lscount=$(ls -A1 | wc -l)
        if [[ ${lscount} -ne 0 ]]; then
            func_get_dir_userInput
        fi
        func_get_index_userInput
        func_get_index_rc
        func_test_index_rc
        func_clean_up
    }
else
    getUrl=$1
    MAIN (){
    if [[ -f /usr/bin/tput ]]; then
        func_set_colors
    fi
    func_start
    func_get_index_rc
    func_test_index_rc
    func_clean_up
    }
fi

MAIN
