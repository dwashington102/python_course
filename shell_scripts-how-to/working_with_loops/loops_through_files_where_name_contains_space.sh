#!/usr/bin/bash
#
IFS=$'\n'

for i in $(find . -type f)
do
    printf "Filename: \"${i}\"\n"
done
