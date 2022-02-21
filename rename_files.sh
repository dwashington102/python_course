#!/usr/bin/bash


tStamp=$(date +%Y%m%d_%H%M)

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


func_get_choice () {
    printf "\nNo files with the extension ${ext_type} found in current directory"
    printf "\n${bold}${yellow}WARNING WARNING WARNING WARNING WARNING${normal}${boldoff}"
    printf "\n"
    choice='abc'
    while [ ${choice} = 'abc' ]
    do
        printf "\nDo you want to rename ALL files that include the text ${ext_type}:\n${normal}"
        printf "Type "yes" to RENAME ALL FILES IN CURRENT DIRECTORY that include the text \"${ext_type}\"\n" 
        printf 'Type "exit" to exit the script\n'
        printf '\n>>> '
        read choice
        IFS=$'\n'
    done
}


func_get_ext () {
    printf "Input Ext.:\t"
    read ext_type

}

func_get_files() {
IFS=$'\n'
#ls -1 *.${ext_type}  > /dev/null 2>&1
file_count=`find . -maxdepth 1 -type f -name "*.${ext_type}" | wc -l`
if [ ${file_count} -gt 0 ]; then
    printf "DEBUG >>> entered func ${FUNCNAME[0]} --- entered if"
    func_rename_files
else
    #ls -1 *${ext_type}* > /dev/null 2>&1 
    wildcard_file_count=`find . -maxdepth 1 -type f -name "*${ext_type}*"  | wc -l`
    if [ ${wildcard_file_count} -gt 0 ]; then
        func_rename_files_wildcard
    else
        printf "\nNo files with the extension ${ext_type} found in current directory"
        printf '\n'
        exit 2
    fi
fi
}


func_rename_files() {
printf "DEBUG >>> entered func ${FUNCNAME[0]}"
    file_count=1
    tot_files=0
    for get_fileName in `ls -1 *.${ext_type} | wc -l`
    do
	printf "DEBUG >>> ${get_fileName}\n"
        sleep 10
        if [ ${get_fileName} -lt 1 ]; then
        #if [ $? -eq 1 ]; then
            printf "\nThe ls command failed after initially running successfully"
            printf '\n'
            exit 1
        else
            printf "\nFile Number: (${file_count})\t File Name: ${get_fileName}"
            printf "\nRename actions: mv ${get_fileName} ${tStamp}_${file_count}.${ext_type}"
            printf "\n"
            mv ${get_fileName} ${tStamp}_${file_count}.${ext_type}
            printf "\n"
            file_count=$((file_count + 1))
            tot_files=$((tot_files + 1))
        fi
    done
    printf "\nTotal Files Renamed: ${tot_files}"
}

func_rename_files_wildcard() {
    file_count=1
    tot_files=0
    func_get_choice
    if [ ${choice} = 'yes' ]; then
        for get_fileName in `ls -1 *${ext_type}*`
        do
            if [ $? -eq 1 ]; then
                printf "\nThe ls command failed after initially running successfully"
                printf '\n'
                exit 1
            else
                printf "\nFile Number: (${file_count})\t File Name: ${get_fileName}"
                printf "\nRename actions: mv ${get_fileName} ${tStamp}_${file_count}.${ext_type}"
                printf "\n"
                mv ${get_fileName} ${tStamp}_${file_count}.${ext_type}
                printf "\n"
                file_count=$((file_count + 1))
                tot_files=$((tot_files + 1))
            fi
        done
    printf "\nTotal Files Renamed: ${tot_files}"
    elif [ ${choice} = 'exit' ]; then
        printf "\nNo files in the current directory were renamed...exiting"
    else
        printf "\nInvalid entry...try again"
        choice='abc'
    fi
}




MAIN () {
    func_set_colors
    func_get_ext
    func_get_files
    printf '\n'
}


MAIN
exit 0
