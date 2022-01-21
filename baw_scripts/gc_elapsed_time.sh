#!/usr/bin/env bash

read -p "Input GC Logname: " get_gc_log

get_gc_longrunning=`egrep -m4  exclusive-"(start |end )" ${get_gc_log}`
printf "\n${get_gc_longrunning"
printf "\n"
#do
#    printf "\nDEBUG >>> get_gc_longrunning: ${get_gc_longrunning}"
#    printf "\n"

#done


exit 0

