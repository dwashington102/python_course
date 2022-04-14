#!/usr/bin/bash


gitdirLoc='$HOME/GIT_REPO'

IFS=$'\n'
topdirArray=( $(find . -maxdepth 1 -type d -exec basename {} \; | sort -u | awk -F'.' '{print $1}' | sort -u))


arrCount=1
printf "\n"
for myDir in ${topdirArray[*]}
do
    printf "DEBUG >>> \n%s" "${topdirArray[*]}"
    sleep 10
    dirArray=( $(find . -maxdepth 1 -name "$myDir.*" -type d -exec {} \;))
    printf "Count: $arrCount - $dirArray\n"
    arrCount=$((arrCount + 1 ))
done
