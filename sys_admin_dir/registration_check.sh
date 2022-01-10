#!/bin/bash

func_test_xwin (){
# Calls functions: func_running_reg_gui
    printf "Checking XWindows Status:\t"
    ps -e | grep tty | grep Xorg &>/dev/null
    if [ $? == 0 ]; then
        printf "Running"
        func_running_reg_gui
    else
        printf "NOT Running...attempting the wall command"
        wall -n 'This computer is not registered.  Registration is required when accessing internal IBM resources' &>/dev/null
    fi
    printf "\n"
}

func_running_reg_gui (){                                                                                                                                                                      
    printf "\n\n\n\n"
    printf "Registration GUI status:\t"
    REGPROC='python3 /opt/ibm/registration/registration.py'
    /usr/bin/pgrep -f "$REGPROC" &>/dev/null
    if [ $? == 0 ]; then
        printf "Running"
    else
        printf "NOT Running"
        zenity --warning --width=400 --height=200 --text 'THIS COMPUTER IS NOT REGISTERED.\nRegistration is required when accessing internal IBM resources.\n\nTo register the compture: python3 /opt/ibm/registration/registration.py' &>/dev/null
    fi
    printf "\n"
}

func_test_py3 (){
# Confirm if python3 is installed on the server
# Calls functions: func_test_py2
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
# Confirm if python2 is installed on the server only if python3 does not exist
    printf "\n"
    printf "Checking Python2 Installation:\t"
    command -v python2 &>/dev/null
    if [ $? == 0 ]; then
        printf "Installed"
    else
        printf "NOT Installed"
        printf "\nPython2 nor Python3 is installed"
        printf "\nPython is required to run the registration.py script "
        exit 0
    fi
    printf "\n"
}

func_test_regpy (){
# Confirm if IBM register.py is installed on the server
# If the register.py is invalid or does not exist the script will exit
# The register.py is included in ibm-anaconda package
    printf "\n"
    IBMREG=/opt/ibm/registration/registration.py
    printf "Checking for file registration.py:\t"
    if [ -f "$IBMREG" ]; then
        if [ -s "$IBMREG" ]; then
            printf "Valid"
        else
            printf "INVALID"
            printf "\nregistration.py is invalid"
            printf "\nInstall latest version of ibm-anaconda pkg"
            exit 0
        fi
    else
        printf "\nregistration.py does not exists"
        printf "\nInstall latest version of ibm-anaconda pkg"
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