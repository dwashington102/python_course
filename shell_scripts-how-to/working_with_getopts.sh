#!/usr/bin/sh
:<<'COMMENTS'
Script copies file to the Production machines on the network


Exit Codes:
101 - check_copyfile(): $copyfile NOT FOUND
COMMENTS

function usage (){
        help
        exit 1
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
        printf "\nCopyfile not set: '${copyfile}'\n"
        copyfile=$HOME/keydb_20190510.kdbx
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
            printf "scp to ${target}\n"
            # scp ${copyfile} ${userid}@${target}:~/.
        else
            printf "Unable to reach ${target}\n"
        fi
    done
}


function test_raptors() {
    declare -a raptors=("k430-raptor" "x1-raptor" "p50-raptor")
    IFS=$'\n'
    for target in ${raptors[@]}
    do
        baseuserid=$(basename --suffix=-raptor "$target")
        userid="$baseuserid""user"
        ping -W2 -c1 -i1 ${target} 
    done
}


main (){
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

    if [ -z "$1" ]; then
        printf "NO ARGS passed\n"
        usage
    fi    

    checkcopy
    do_scp
}

main "$@"
