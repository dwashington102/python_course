#!/bin/bash



func_test_xwin (){
# This function will launch the registration.py GUI if a XWin session is running
# If XWindows is not running, the wall command is used to nag user
# Calls functions: 
# > func_running_reg_gui
# 
    printf "\n"
    printf "Checking XWindows Status:\t"
    ps -e | grep tty | grep Xorg &>/dev/null
    if [ $? == 0 ]; then
        printf "Running"
        func_running_reg_gui
        python3 /opt/ibm/registration/registration.py
    else
        printf "NOT Running...attempting the wall command"
        sleep 5
        wall -n 'THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources' &>/dev/null
        wall -n 'To register the computer:\npython3 /opt/ibm/registration/registration.py' &>/dev/null
        # MUST TEST THE FOLLOWING COMMAND
        #perl-ne 'chomp;printf "%- 79s\n",$_;' myfile | wall
    fi
    printf "\n"
}

func_running_reg_gui (){                                                                                                                                                                      
# This function checks to see if the registration.py GUI is already running
# Calls functions:
# > 
#
    printf "\n\n\n\n"
    printf "Registration GUI status:\t"
    REGPROC='python3 /opt/ibm/registration/registration.py'
    /usr/bin/pgrep -f "$REGPROC" &>/dev/null
    if [ $? == 0 ]; then
        printf "Running"
    else
        printf "NOT Running"
        zenity --warning --width=400 --height=200 --text 'THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources.\n\nTo register the computer:\npython3 /opt/ibm/registration/registration.py' &>/dev/null
    fi
    printf "\n"
}

func_test_py3 (){
# This function confirms if python3 is installed on the server
# Calls functions: 
# > func_test_py2
#
    printf "\n"
    printf "Checking Python3 Installation:\t"
    command -v python3 &>/dev/null
    if [ $? == 0 ]; then
        printf "Installed"
    else
        printf "NOT installed"
        func_test_py2
    fi
    printf "\n"
}

func_test_py2 (){
# This function confirms if python2 is installed on the server
# Calls functions: 
# > 
#
    printf "\n"
    printf "Checking Python2 Installation:\t"
    command -v python2 &>/dev/null
    if [ $? == 0 ]; then
        printf "Installed"
    else
        printf "NOT Installed"
        printf "\nPython2 nor Python3 is installed"
        printf "\nPython is required to run the registration.py script "
        printf "\n"
        exit 0
    fi
    printf "\n"
}

func_test_regpy (){
# This function confirm if IBM register.py is installed on the server
# If the register.py is invalid (0 bytes) or does not exist the script will exit
# The register.py is included in ibm-anaconda package
# Calls functions: 
# > 
#
    printf "\n"
    IBMREG=/opt/ibm/registration/registration.py
    printf "Checking for file registration.py:\t"
    if [ -f "$IBMREG" ]; then
        if [ -s "$IBMREG" ]; then
            printf "Valid"
        else
            printf "INVALID"
            printf "\nregistration.py is invalid"
            printf "\nInstall latest version of ibm-anaconda package"
            printf "\n"
            exit 0
        fi
    else
        printf "\nregistration.py does not exists"
        printf "\nInstall latest version of ibm-anaconda pkg"
        printf "\n"
        exit 0
    fi
    printf "\n"
}


MAIN (){
    printf "\n"
    func_test_py3
    func_test_regpy
    func_test_xwin
    printf "\n"
}


MAIN
exit 0