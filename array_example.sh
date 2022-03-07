#!/bin/sh


<< 'COMMENT'
Script pulls fixlet entries from BES client log, writing each fixlet number to an array.

Location of log file:
/var/opt/BESClient/__BESData/__Global/Logs/20220304.log"

--- Entries in BES Client log ---
Relevant - Re-Register NewBuild Linux Endpoint (fixlet:2070889)
COMMENT

export LOGFILE="${HOME}/BESLogs/TODAY.log"
declare -a myArray

arraycount=1
arrayindex=0

export IFS=$'\n'
for get_fixlet_id in $(command grep --extended-regexp '.*Relevant.*\(fixlet:[[:digit:]].*\)$' "${LOGFILE}" | command grep --invert-match --ignore-case --max-count 20 "not relevant" | awk -F"\\\(fixlet:" '{print $2}' | awk '{gsub(/)/, "") ; print }') 
do
    #printf "DEBUG >>> fixlet_id =  %s\n" "${get_fixlet_id}"
    #printf "DEBUG >>> Array Index: \t%s\t\n" "${arrayindex}"
    #printf "DEBUG >>> Array count: \t%s\t\n\n" "${arraycount}"
    myArray[$arrayindex]=$get_fixlet_id
    arraycount=$((arraycount + 1))
    arrayindex=$((arrayindex + 1)) 
    #sleep 5
done

len=${#myArray[@]}

printf "\nDEBUG >>> Number of items in Array:\t%s\n" "${#myArray[@]}"
printf "\nDEBUG >>> Content of Array: \n%s\n" "${myArray[*]}"


