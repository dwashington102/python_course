#!/usr/bin/bash
IFS=$'\n'
for get_fixlet_id in $(grep -m10 -E '.*Relevant.*\(fixlet:[[:digit:]].*\)$' $PWD/TODAY.log | grep -vi "not relevant")
do
    printf "\nFull string NAME: $get_fixlet_id"
    set_fixlet_name=$(echo $get_fixlet_id :w!
    
    #set_fixlet_name=$(echo $get_fixlet_id | awk -F"\\\(fixlet" '{print "(fixlet"$2}') <--Hack around
    printf "\nOnly Fixlet ID: $set_fixlet_name"

done
printf "\n"

