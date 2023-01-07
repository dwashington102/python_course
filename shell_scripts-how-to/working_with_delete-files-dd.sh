#!/usr/bin/sh
:<<'COMMENTS'
Script takes these actions on all files in current directory
-> Get filesize
-> Overwrite file contents using dd with a bs = filesize
-> truncate filesize to 0
-> finally delete file
COMMENTS

IFS=$'\n' 

for i in $(find . -type f)
do
    getsize=$(ls -l ${i} | awk '{print $5}')
    printf "Delete file: '${i}' filesize=${getsize}\n"
    dd if=/dev/urandom of='${i}' bs=${getsize} count=2 conv=notrunc
    truncate -s0 "${i}"
    rm -f "${i}"
done
