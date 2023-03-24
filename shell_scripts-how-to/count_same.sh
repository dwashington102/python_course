#!/usr/bin/bash
"""
Script parses the inputfile looking for duplicate entries in the file
"""

inputfile="./Code42.txt"

loopcount=1
totaldups=0
for line in $(cat ${inputfile} | command grep member | sort -u)
do
    count=0
    count=$(grep -c ${line} ${inputfile})
    if [[ ${count} -gt 1 ]]; then
        printf "${loopcount} - Total entries for ${line}: ${count}\n"
        loopcount=$((loopcount+1))
        totaldups=$((${totaldups} + ${count}))
    fi
done

printf "Total Number of Duplicates: ${totaldups}\n"
