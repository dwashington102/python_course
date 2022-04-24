#!/usr/bin/bash

:<<'COMMENT'
Script gathers a list of files contained in each subdirectory
COMMENT


IFS=$'\n'
topdirArray=( $(find . -maxdepth 1 -type d -exec basename {} \; | sort -u | awk -F'.' '{print $1}' | sort -u) )

arrCount=1
for myDir in ${topdirArray[@]}
do
    #printf "DEBUG >>> \n%s" "${topdirArray[*]}"
    sleep 2
    dirArray=( $(find "$myDir" -mindepth 1 -maxdepth 1 -type f -exec basename {} \;) )
    #printf "Count: $arrCount - $dirArray\n"
    printf "\n(%s) Dir Name: %s\n\tNumber of Files: %s" "$arrCount" "$myDir" "${#dirArray[@]}"
    arrCount=$((arrCount + 1 ))
    printf "\n"
done
printf "\n"
