#!/usr/bin/env bash

IFS=$'\n'
#for get_gc in `cat gc_28T16:2.txt | awk -F'[""]' '{print $2}'`
for get_gc in `cat gc_28T16:2.txt`
do
    printf "\nContainer: ${get_gc}\n"
    grep -B3 "gc-op.*28T16:2" native_stderr-DUP0002.log | grep ${get_gc} | awk -F\" '{x+=$6}END{printf "%2.2f MB\n",x/1024/1024}'
    sleep 2
    printf "\n"
done

