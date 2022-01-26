#!/usr/bin/bash

# Script simplies the output of the 'ip' command used to view the IP address, current state, and MTU of interfaces

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

exit 0