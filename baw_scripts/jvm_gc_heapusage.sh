#!/usr/bin/env bash

# gc_28T16:2.txt was built using the timestamps taken from the native_stderr.log
:: <<'COMMENTS'
example of native_stderr.log contents
<gc-op id="79" type="scavenge" timems="29.761" contextid="76" timestamp="2022-01-21T11:26:23.884">
COMMENTS


IFS=$'\n'
#for get_gc in `cat gc_28T16:2.txt | awk -F'[""]' '{print $2}'`
for get_gc in `cat gc_28T16:2.txt`
do
    printf "\nContainer: ${get_gc}\n"
    grep -B3 "gc-op.*28T16:2" native_stderr-DUP0002.log | grep ${get_gc} | awk -F\" '{x+=$6}END{printf "%2.2f MB\n",x/1024/1024}'
    sleep 2
    printf "\n"
done

