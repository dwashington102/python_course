#!/usr/bin/env bash

# Script is used to extract the allocation failures from gc log
# The script prompts the user for 2 pieces of information:
# gc_log = garbage collection log file name
# get_af = The number of allocation failures to gather.


MAIN() {
    get_log_info
    gc_af
}

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

get_log_info() {
    read -p "gc Log Filename: " get_gclog
    read -p "How many Allocation Failures to review: " get_af
}

gc_af() {
    loopcount=1
    for tbrec in `grep  -i totalbytesrequested= ${get_gclog} | awk -F"totalBytesRequested=" '{print $2}' | awk -F'[""]' '{print $2}' | sort -nr  | head -$get_af`
    do
        printf "\n============================="
        printf "\nAllocation Failure $loopcount:"
        printf "\n=============================\n"
        grep -B3 -A6 -i "totalbytesrequested=\"${tbrec}" ${get_gclog}
        loopcount=$((loopcount+1))
        sleep .50
    done
}


MAIN
exit 0
