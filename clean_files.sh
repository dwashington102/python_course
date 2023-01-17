#!/usr/bin/bash
:<<'COMMENTS'
Script takes file extension from user input and performs
a dd against each file.
COMMENTS


func_dd () {
    file_count=$(find . -maxdepth 1 -type f -name "*${ext_type}" | wc -l)
    if [ ${file_count} -gt 0 ]; then
        for getfile in $(ls -1 *${ext_type})
            do
                getsize=$(ls -l ${getfile} | awk '{print $5}')
                echo "Filename: ${getfile} --- Size: ${getsize}"
                sleep 1
                dd if=/dev/urandom of=${getfile} bs=${getsize} count=2 conv=notrunc
                truncate -s0 ${getfile}
            done
    else
        printf "\nNo files with the extension ${ext_type} found in current directory"
        printf "\n"
    fi
}


func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}


func_get_ext () {
    if [ -z $1 ]; then
            printf "Input File Ext.:\t"
            read ext_type
        else
            ext_type="$1"
        fi
}


main () {
    func_set_colors
    printf "\nSCRIPT WILL dd ALL FILES IN THIS DIRECTORY:\t"
    echo $PWD

    if [ -z "${ext_type}" ]; then
        func_get_ext
    fi

    if [ "${ext_type}" == "all" ]; then
        ext_type="*"
    fi

    printf "Preparing to dd files with ext. ${ext_type}\n"
    sleep 5
    func_dd
    file $(command bleachbit -v) &>/dev/null
    if [ "$?" == "0" ]; then
        printf "\nCalling bleachbit..."
        bleachbit -s *${ext_type} 2>/dev/null
    fi
}


:<<'COMMENTS'
Following 2 lines takes user argument ("$@") as array
Sets ext_type to 1st element in the array, before beginning the process
to clean file types of the ext_type

Found I have to pass that $@ BEFORE going into main()
COMMENTS

#ext=("$@")
#ext_type=${ext[0]}

if [[ ! -z "$1" ]]; then
        if [[ "$1" == "-h" || "$1" == "-help" ]]; then
                printf "Program attempts to overwrite and remove all files in current directory\n"
                printf "Running the script without any flags will prompt for file"
                printf "\n\nUsage : clean_files.sh [options]"
                printf "\n  -h, --help    Print this help text"
                printf "\n  -e, --ext <extensiont type>   Delete files with given ext.type"
                printf "\n  -a, --all     Overwrite  and delete all files in the directory"
                printf "\n"
                exit 0
        elif [[ "$1" == "-e" || "$1" == "--ext " ]]; then
                ext_type="$2"
                if [[ -z $2 ]]; then
                        printf "Missing extension type"
                        printf "\n  -e, --ext <extensiont type>   Delete files with given ext.type"
                        exit 0
                fi
        elif [[ "$1" == "-a" || "$1" == "--all " ]]; then
                ext_type="*"
        else
                printf "Invalid option -- '${1}'"
                printf "\nTry '$0 --help'\n"
                exit 0
        fi
fi


main 
