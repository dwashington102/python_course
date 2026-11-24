#!/usr/bin/env bash

jcore1=""
jcore2=""

while [[ ! -f "$jcore1" ]]; do
    printf "Enter first valid Javacore filename: \t"
    read -r jcore1
done


while [[ ! -f "$jcore2" ]]; do
    printf "Enter second valid Javacore filename: \t"
    read -r jcore2
done


printf "%.s=" {1..50}; printf "\n"
printf "\nTHREADINFO\t    1-CPUTIME\t2-CPUTIME    Time DIFF\n"
printf "%.s=" {1..50}; printf "\n"
printf "\n"
join -a 1 -a 2 \
    <(\
      grep -e '3XMTHREADINFO ' -e 3XMCPUTIME "${jcore1}" | \
        grep -v 'Anonymous native thread' | \
        sed '$!N;s/\n/ /' | \
        sed 's/3XMTHREADINFO.*J9VMThread://g' | \
        sed 's/,.*CPU usage total://g' | \
        sed 's/ secs.*//g' | \
        sort
     )\
    <(\
      grep -e '3XMTHREADINFO ' -e 3XMCPUTIME "${jcore2}" | \
        grep -v 'Anonymous native thread' | \
        sed '$!N;s/\n/ /' | \
        sed 's/3XMTHREADINFO.*J9VMThread://g' | \
        sed 's/,.*CPU usage total://g' | \
        sed 's/ secs.*//g' | \
        sort
     ) | \
       awk '{ printf "%s %.9f\n", $0, $3-$2 }' | sort -nr -k 4

exit 0

