#!/usr/bin/bash

:<< 'COMMENT'
Useful when it comes to padding output with zero

example:
Rather than printing
1
2
3

We get
001
002
003

For renaming files using padding method see
ibm-kvm-clone script
COMMENT

count=1

while [[ $count -le 100 ]]
do
    printf "\n%03d%s" "$count"
    count=$((count + 1))
done
printf "\n"

# Ben's Solution:
# for part in $(seq -f "%03g" 1 $NUM_OF_CHUNKS); do SOURCE=$(( 10#$part-1 )); echo "$SOURCE"; echo "$part"; done
