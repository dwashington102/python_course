#!/bin/bash

file $(which w) &>/dev/null
if [ $? == 0 ]; then
       #XWindows Running Section	
       # This command ONLY gathers the 1st instance of running XWindows session
       get_display=$(w -h | command grep -m1 -E '[[:alpha:]]\s:[[:digit:]]\s' | awk '{print $2}')
       if [ -z "$get_display" ]; then
	       #get_display is empty indicates connected users are not running Xwindows session
       	       #The script should exit here because if XWindows is not running the registration.py will not run.
	       printf "\n No connected users are running in XWindows session"
	       printf "\n"
	       exit 1
	else
	       DISPLAY=${get_display}
	fi
else
       #The w command was not found.
       # The w command is needed to gather a list of connected users, without the w command exit script here
       printf "\n 'w' command not found"
       printf "\n"
       exit 1

fi
printf "\nDISPLAY var: '$DISPLAY'"
printf "\n"
exit 0

