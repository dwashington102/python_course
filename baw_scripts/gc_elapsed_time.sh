#!/usr/bin/env bash

read -p "Input GC Logname: " get_gc_log

get_gc_longrunning=`egrep -m4  exclusive-"(start |end )" ${get_gc_log}`
printf "\nDEBUG >>> ${get_gc_longrunning"
#do
#    printf "\nDEBUG >>> get_gc_longrunning: ${get_gc_longrunning}"
#    printf "\n"

#done


exit 0

