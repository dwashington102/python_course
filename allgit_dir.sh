#!/usr/bin/bash

:<<'COMMENT'
Script gathers a list of files contained in each subdirectory
COMMENT


IFS=$'\n'
mapfile -t topdirArray < <(find . -maxdepth 1 -type d -not -path "." -exec basename {} \; | sort -u | awk -F'.' '{print $1}' | sort -u)

arrCount=1
for myDir in "${topdirArray[@]}"
do
    #printf "DEBUG >>> \n%s" "${topdirArray[*]}"
    sleep 2
    IFS=$'\n'
    mapfile -t ar_files < <(find "$myDir" -type f -exec basename {} \;)
    # mapfile -t ar_files < <(find "$myDir" -mindepth 1 -type f -exec basename {} \;)
    printf "\n(%s) Dir Name: %s\n\tNumber of Files: %s" "$arrCount" "$myDir" "${#ar_files[@]}"
    arrCount=$((arrCount + 1 ))
    printf "\n"
done
printf "\n"
