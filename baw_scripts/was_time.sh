#!/usr/bin/env bash

#


grep='grep --color=NEVER'

MAIN() {
    func_get_log
    func_first_tstamp
    func_get_pid
    func_last_tstamp
}

func_get_log() {
    read -p "Logfile Name: " systemoutlog 
    printf "\n" 
    printf "\nFilename: $systemoutlog"
}

func_first_tstamp(){
    printf "\n" 
    printf "First Timestamp:"
    grep -m1 ^\\[[[:digit:]] $systemoutlog  | awk -F'[\\]]' '{print $1"]"}'
}

func_get_pid() {
    printf "JVM pids:\n" 
    grep -E "^WebSphere.*process id" $systemoutlog | awk -F"running with process name" '{print $2}'
}

func_last_tstamp() {
    printf "Last Timestamp:"
    tac $systemoutlog | grep -m1  ^\\[[[:digit:]] | awk -F'[\\]]'  '{print $1"]"}'
}

MAIN
exit 0

