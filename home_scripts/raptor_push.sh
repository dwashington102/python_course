#!/usr/bin/sh
:<<'COMMENTS'
Script copies file to the Production machines on the network


Exit Codes:
101 - check_copyfile(): $copyfile NOT FOUND
102 - check_host(): Attempt to run script on server other than Prod. Hub
COMMENTS

function usage (){
        help
        exit 1
}



function check_host()
{
    hostmach=$(hostname -s)
    if [[ "${hostmach}" != "p340-raptor" ]]; then
        printf "Script is meant to be ran Production HUB...exit(102)\n"
        exit 102
    fi
}

function help (){
   printf "Script copies file provided to all Production devices\n"
   printf "Usage:\n"
   echo  -e "-f\tLocal file to scp"
   echo  -e "-t\tTest connection to Production Servers"
   echo  -e "-h\tDisplay this messages"
   exit 0
}


function checkcopy (){
    if [ -z ${copyfile} ]; then
        printf "\n"
        printf "Copyfile not set: '${copyfile}'\n"
        copyfile=$HOME/keydb_20190510.kdbx
        printf "Setting copyfile to ${copytfile}.\n"
        sleep 2
    fi

    if [ ! -f $copyfile ]; then
        printf "$copyfile NOT FOUND...exit(1)\n"
        exit 101
    fi
}


function do_scp (){
    declare -a raptors=("k430-raptor" "x1-raptor" "p50-raptor")
    IFS=$'\n'
    for target in ${raptors[@]}
    do
        baseuserid=$(basename --suffix=-raptor "$target")
        userid="$baseuserid""user"
    
        ping -W2 -c1 -i1 ${target} &>/dev/null
        if [ "$?" == "0" ]; then 
            printf "%0.s-" {1..50}
            printf "\n"
            printf "scp to ${target}\n"
            scp -vp ${copyfile} ${userid}@${target}:~/. &>/dev/null
            if [[ "$?" == "0" ]]; then
                basefile=$(basename --suffix="/.*" ${copyfile})
                printf "File timestamp:\n"
                ssh ${userid}@${target} 'ls -ltr ~' | grep ${basefile}
            else
                printf "scp FAILED\n"
            fi
        else
            printf "%0.s-" {1..50}
            printf "\n"
            printf "Unable to reach ${target}\n"
        fi
    done
}


function test_raptors() {
    declare -a raptors=("k430-raptor" "x1-raptor" "p50-raptor")
    IFS=$'\n'
    for target in ${raptors[@]}
    do
        printf "%0.s-" {1..50}
        printf "\n"
        printf "Testing connection to ${target}\n"
        ping -W2 -c1 -i1 ${target}  &>/dev/null
        if [[ "$?"  == "0" ]]; then
            printf "Ping Success to ${target}\n"
        else
            printf "Ping FAILURE to ${target}\n"
        fi
    done
    exit 0
}


main (){
    check_host
    copyfile=""
    while getopts ":f:th" FLAG;
    do
        case $FLAG in
            h) help  ;;
            f) copyfile="$OPTARG";;
            t) test_raptors ;;
            *) usage ;;
        esac
    done

    # Enable if user must pass argument to script
    if [ -z "$1" ]; then
        printf "NO ARGS passed\n"
        usage
    fi    

    checkcopy
    do_scp
}

main "$@"
