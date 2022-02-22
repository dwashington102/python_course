#!/usr/bin/bash

# Script simplies the output of the 'ip' command used to view the IP address, current state, and MTU of interfaces



# Usage function
usage (){
    cat << EOF
Usage: $0 [--help|--all]

    -a, --all    Will print the network information for all interfaces
    -h, --help   Show this help
EOF
}

get_all (){
# Write each interface to an array
get_intface=($(ip a | command grep mtu | awk -F":" '{print $2}'))
IFS=$'\n'
if [[ ${#get_intface[@]} ]]; then
    for i in ${get_intface[*]}
    do
        printf "\nInterface Name: $i\n"
        ip addr list ${i} | command grep -E '(state|inet)'
    done    
else
    printf "\nThe 'ip a' command failed to return any interfaces"
fi
printf "\n"
}

MAIN (){
if [ "$1" = "--all" -o "$1" = "-a" ]; then
    get_all
    exit 0
fi

if [ "$1" = "--help" -o "$1" = "-h" ]; then
    usage 
    exit 0
fi

if [ -n "$1" ]; then
    printf "\nUnknown parameter '$1'\n" >&2
    usage
    exit 1
fi
}


MAIN
exit 0