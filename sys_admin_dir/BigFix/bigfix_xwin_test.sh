#!/bin/bash
# 2022-11-13
# Script will set a DISPLAY variable using the output of the 'w' command.
# If the DISPLAY variable indicates a XWindow session is running - zenity is used to alert the user
# If the DISPLAY variable indicates a terminal session is running - wall is used to alert the user


# Function confirms if Python3 or Python2
# If a version of Python is not installed, script will exist
func_get_py_ver (){
        command -v python3 &>/dev/null
        if [ $? != 0 ]; then
            command -v python2 &>/dev/null
            if [ $? == 0 ]; then
                printf "\nPython2 is installed"
            else 
                printf "\nNo version of Python installed"
                printf "\nInstall Python3"
                exit 1
             fi
        else
                printf "\nPython3 is installed"                                                                                                    
        fi
}



# Function checks the output of the 'w' command extracting the first instance of indicating a XSession under Xorg
# Example from the output of the 'w' command that indicates a running Xsession (Xorg)
# myuser :1       :1   Mon19   ?xdm?   4:46m  0.00s /usr/libexec/gdm-x-session --register-session --run-script gnome-session
func_get_xdisplay (){
       get_xdisplay_var=$(w -h | command grep -m1 -E '(xfce.*session|gdm.*session)' | awk '{print $2}')
       #get_xdisplay_var=$(w -h | /usr/bin/grep -m1 -E '[[:alnum:]]\s:[[:digit:]]\s' | awk '{print $2}')
       if [ ! -z "$get_xdisplay_var" ]; then
              printf "\nDEBUG >>> Captured Xsession"
	       DISPLAY=${get_xdisplay_var}
              zenity --warning --width=400 --height=200 --text "THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources.\n\nTo register the computer run the command:\npython3 /opt/ibm/registration/registration.py" &>/dev/null
       fi
}


# Function checks the output of the 'w' command extracting the first instance of indicating a terminal session
# Example from the output of the 'w' command that indicating a running terminal session
# myuser pts/8    p     10:36    2:23m  0.26s  0.26s /usr/bin/zsh
func_get_term (){
       get_terms_var=$(w -h | command grep -m1 -E '[[:alnum:]]\s+(pts|tty)' | awk '{print $2}')
       if [ -z "$get_terms_var" ]; then
	       printf "\nNo users currently connected"
	       printf "\n"
              exit 1
       else
              printf "\nDEBUG >>> Captured Terminal Session"
	       DISPLAY=${get_terms_var}
       fi
}

MAIN (){
DISPLAY=""

func_get_py_ver
file $(which w) &>/dev/null
if [ $? == 0 ]; then
       func_get_xdisplay
       if [ -z $DISPLAY ]; then
             func_get_term
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
