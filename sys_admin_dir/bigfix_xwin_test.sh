#!/bin/bash
# 2022-11-13
# Script will set a DISPLAY variable using the output of the 'w' command.
# If the DISPLAY variable indicates a XWindow session is running - zenity is used to alert the user
# If the DISPLAY variable indicates a terminal session is running - wall is used to alert the user


# Function checks the output of the 'w' command extracting the first instance of indicating a XSession under Xorg
# Example from the output of the 'w' command that indicates a running Xsession (Xorg)
# myuser :1       :1   Mon19   ?xdm?   4:46m  0.00s /usr/libexec/gdm-x-session --register-session --run-script gnome-session
get_xdisplay (){
       get_xdisplay_var=$(w -h | /usr/bin/grep -m1 -E '[[:alnum:]]\s:[[:digit:]]\s' | awk '{print $2}')
       if [ ! -z "$get_xdisplay_var" ]; then
	       DISPLAY=${get_xdisplay_var}
       fi
}


# Function checks the output of the 'w' command extracting the first instance of indicating a terminal session
# Example from the output of the 'w' command that indicating a running terminal session
# myuser pts/8    p     10:36    2:23m  0.26s  0.26s /usr/bin/zsh
get_term (){
       get_terms_var=$(w -h | /usr/bin/grep -m1 -E '[[:alnum:]]\s(pts|tty)' | awk '{print $2}')
       if [ -z "$get_terms_var" ]; then
	       printf "\nNo users currently connected"
	       printf "\n"
       else
	       DISPLAY=${get_terms_var}
       fi
}

MAIN (){
DISPLAY=""
file $(which w) &>/dev/null
if [ $? == 0 ]; then
       get_xdisplay
       if [ -z $DISPLAY ]; then
             get_term
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
}

MAIN
exit 0
