#!/usr/bin/bash

<<'COMMENTS'
Script locates the rpm files in all subdirectories
Prints the RPM filename
Prints the sha256sum outpu for the file name

Run the script in a dictory, where there are subdirectories that hold multiple rpms
COMMENTS

RPMDIR="$1"
if [[ -z $RPMDIR ]]; then
    pushd $HOME/Downloads
    RPMDIR=$PWD
fi

for i in $(find ${RPMDIR} -name '*rpm')
    do
        fileName=$(echo $i)
        baseFileName=$(echo "$fileName" | awk -F"/" '{print $NF}')
        shaValue=$(sha256sum "$fileName" | awk -F" " '{print $NR}')


        printf "\nFilname: %s" "$fileName"
        printf "\nBase Filename: %s" "$baseFileName"
        printf "\nshaValue: %s\n" "$shaValue"
    done

