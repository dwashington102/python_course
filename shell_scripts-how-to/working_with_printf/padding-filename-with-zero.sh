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