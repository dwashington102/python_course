#!/usr/bin/bash
:<<'COMMENTS'
Script takes file extension from user input and performs
a dd against each file.
COMMENTS



# Begin Common Functions

function set_dts () {
    unset DTS
    DTS=$(date +"%Y%m%d_%H%M%S")
}


function create_log() {
    set_dts
    if [ "$(id -u)" == 0 ]; then
        logdir="/var/log"
    else
        logdir="/var/tmp"
    fi

    if [ ! -d ${logdir} ]; then
        /usr/bin/mkdir -p ${logdir}
    fi

    logname=$(basename --suffix=".sh" "$0")
    if [ -d ${logdir} ]; then
        logfile=${logdir}/${logname}_${DTS}.log
    else
        logfile=/tmp/${logname}_${DTS}.log
    fi

    /usr/bin/truncate -s0 "${logfile}"
}


function log_message(){
    local message

    if [[ "${loginit}" == 1 ]]; then
        message="Starting application"
        loginit=$((loginit + 1))
    elif [[ ${loginit} == 99 ]]; then
        message="All actions completed"
    else
        message="$1"
    fi

    printf "%s: $message\n" "$(date --rfc-3339=seconds)" >> "${logfile}"
}


function check_uid (){
    if [[ "$(id -u)" -ne "0" ]]; then
        printf "Script must be run as root or using sudo...exit(100)\n"
        exit 100
    fi
    printf "Running script as root user.\n"
}
# End Common Functions


func_dd () {
    log_message "${FUNCNAME[0]}()"
    mapfile -t file_list < <(find "$PWD" -maxdepth 1 -type f -name "*${ext_type}")
    log_message "\tdirectory: $PWD"
    log_message "\text: ${ext_type}"
    log_message "\titems found: ${#file_list[@]}"
    if [ "${#file_list[@]}" -gt 0 ]; then
        sleep 5
        loop_count=0
        if command bleachbit -v &>/dev/null; then
            bleachbit_on=1
            log_message "\tbleachbit found: ${bleachbit_on}"
        fi

        for f_name in "${file_list[@]}"
            do
                loop_count=$((loop_count + 1))
                f_size=$(stat -c "%s" "${f_name}")
                printf "\nProcessing File (${loop_count}/${#file_list[@]}): %s --- Size(bytes): %s" "${f_name}" "${f_size}"
                log_message "\tProcessing (${loop_count}/${#file_list[@]}): ${f_name} size(bytes): ${f_size}"
                sleep 5
                if [ "$f_size" -gt 0 ]; then
                    printf "\n\t- Calling dd for filename: %s" "${f_name}"
                    dd if=/dev/urandom of="${f_name}" bs="${f_size}" count=2 conv=notrunc &>/dev/null
                    log_message "\t- dd action: rc=$?"
                    printf "\n\t- Truncate filename: %s" "${f_name}"
                    truncate -s0 "${f_name}"
                    log_message "\t- truncate action: rc=$?"
                fi

                # Use bleachbit to erase files
                if [ "${bleachbit_on}" -eq 1 ]; then
                    printf "\n\t- Calling bleachbit for filename: %s" "${f_name}"
                    printf "\n"
                    bleachbit -s "${f_name}" &>/dev/null
                    log_message "\t- bleachbit action: rc=$?"
                fi
                log_message "\tCompleted actions for ${f_name}\n"

                # do not sleep after processing last item in array
                if [[ "${f_size}" -ne 0 && "${loop_count}" -lt "${#file_list[@]}" ]]; then
                    sleep 5
                fi
            done
    else
        printf "\nNo files with the extension %s found in current directory" "${ext_type}"
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
    printf "Input File Extension.:\t"
    read -r ext_type
}


main () {
    create_log
    loginit="1" ; log_message
    func_set_colors
    printf "\nSCRIPT WILL REMOVE ALL FILES IN THIS DIRECTORY that match the given extension:\t"
    echo "$PWD"

    if [ -z "${ext_type}" ]; then
        func_get_ext
    fi

    if [ "${ext_type}" == "all" ]; then
        ext_type="*"
    fi

    printf "Preparing to dd files with ext. '%s'\n" "${ext_type}"
    sleep 5
    func_dd
    loginit="99" ; log_message
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
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Attempts to overwrite and remove all files in current directory\n"
        printf "\nRunning the script without any flags will prompt for file"
        printf "\n\nUsage : clean_files.sh [options]"
        printf "\n  -h, --help    Print this help text"
        printf "\n  -e, --ext <extension type>   Delete files with given ext.type"
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
