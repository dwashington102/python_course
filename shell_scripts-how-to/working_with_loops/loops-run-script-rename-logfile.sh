#!/usr/bin/bash

:<<COMMENT
Script runs the bf_relay_selection.sh script 1000 times
The bf_relay_selection.sh script generates a config file (/tmp/besclient.config)
In order to avoid overwriting the generated /tmp/besclient.config file, each loop
wil rename generated config file (appending loopCount var to the name), before
moving to the next iteration of the loop
COMMENT


loopCount=1 

while [ "$loopCount" -le "10000" ]                                                      
do
    printf "\n%s" "$loopCount"
    ~/GIT_REPO/python_course/sys_admin_dir/BigFix/bf_relay_selection.sh
    mv /tmp/besclient.config /tmp/besclient.config_"$loopCount"
    ((loopCount++))
done
