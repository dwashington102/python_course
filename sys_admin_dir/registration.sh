#!/usr/bin/env bash

#Confirm if registration.py is currently running.  If running display zenity popup and exit
func_check_running_reg () {
	get_reg_pid=$(command pgrep -f 'python.*/opt/ibm/registration/registation.py')
	if [ ! -z "$get_reg_pid" ]; then
	    printf "\nDEBUG >>> registration.py currently running pid=$get_reg_pid\n"
		func_get_xdisplay
        exit 0
	fi
}

#Confirm if python3 or python2 is installed. Exit if no version of python is installed.
func_get_py_ver (){ 
        command -v python3 &>/dev/null
        if [ $? != 0 ]; then
            command -v python2 &>/dev/null
            if [ $? == 0 ]; then
                printf "\nPython2 is installed"
		PYCMD=python2
            else
                printf "\nNo version of Python installed"
                printf "\nInstall Python3"
                exit 1
             fi
        else
                printf "\nPython3 is installed"
		PYCMD=python3
        fi
}

# Confirm if Xsession is running, set DISPLAY env, throw zenity popup before registration GUI is displayed.
func_get_xdisplay (){
       get_xdisplay_var=$(w -h | command grep -m1 -E '(gnome.*session|xfce.*session|gdm.*session)' | awk '{print $2}')
       #get_xdisplay_var=$(w -h | /usr/bin/grep -m1 -E '[[:alnum:]]\s:[[:digit:]]\s' | awk '{print $2}')
       if [ ! -z "$get_xdisplay_var" ]; then
              printf "\nCaptured Xsession"
              DISPLAY=${get_xdisplay_var}
              zenity --warning --width=400 --height=200 --text "THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources.\n\nMinimize all windows and complete registration." &>/dev/null
       fi
}

# If no Xsession is found, use 'w -h' output and wall command to inform user to register computer
func_get_term (){                                                                                                                                                                             
       get_terms_var=$(w -h | /usr/bin/grep -m1 -E '[[:alnum:]]\s+(pts|tty)' | awk '{print $2}')
       if [ -z "$get_terms_var" ]; then
               printf "\nNo users currently connected"
               printf "\n"
              exit 1
       else
	          DISPLAY=${get_terms_var}
	   		  wall /tmp/reg.msg
       fi
}

MAIN (){
DISPLAY=""

func_check_running_reg
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
printf "\nDISPLAY var: '$DISPLAY'\n"
command $PYCMD /opt/ibm/registration/registration.py &>/dev/null
if [ $? != "0" ]; then
    printf "\nRegistration GUI fails to display"
    zenity --warning --width=400 --height=200 --text "THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources.\n\nRegistration GUI failed to display." &>/dev/null
else
    printf "\nRegistration GUI completed"
fi
}

MAIN
