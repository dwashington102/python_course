#!/usr/bin/bash

:<< 'COMMENTS'
Script outputs the first 10 rows of the /etc/passwd file adding the header
"User" "UID"
COMMENTS

awk -F":" '
BEGIN {
    printf "%-8s %-3s\n", "User", "UID" 
}
NR==1,NR==10{ printf "%-8s %3d\n", $1,$3 } ' /etc/passwd
