#!/bin/bash

func_test_xwin (){
    printf "Checking XWindows Status:\n"
    ps -e | grep tty | grep Xorg &>/dev/null
    if [ $? == 0 ]; then
        printf "XWindows is running"
    else
        printf "XWindows is NOT running"
    fi
    printf "\n"
}

func_test_py3 (){
# Confirm if python3 is installed on the server
    printf "\n"
    printf "Checking Python3 Installation:\n"
    command -v python3 &>/dev/null
    if [ $? == 0 ]; then
        printf "Python3 is installed"
    else
        printf "Python3 is not installed"
        printf "DEBUG >>> Testing for python2"
        func_test_py2
    fi
    printf "\n"
}

func_test_py2 (){
# Confirm if python2 is installed on the server only if python3 does not exist
    printf "\n"
    printf "Checking Python2 Installation:\n"
    command -v python2 &>/dev/null
    if [ $? == 0 ]; then
        printf "\nPython2 is installed"
    else
        printf "\nPython2 is not installed"
    fi
    printf "\n"
}

func_test_regpy (){
# Confirm if IBM register.py is installed on the server
# The register.py is included in ibm-anaconda package
    printf "\n"
    IBMREG=/opt/ibm/registration/registration.py
    printf "Checking for file registration.py:\n"
    if [ -f "$IBMREG" ]; then
        if [ -s "$IBMREG" ]; then
            printf "registration.py is valid"
        else
            printf "\nregistration.py is invalid"
            printf "\nInstall latest version of ibm-anaconda pkg"
            exit 0
        fi
    else
        printf "\nregistration.py does not exists"
        printf "\nInstall latest version of ibm-anaconda pkg"
    fi
    printf "\n"
}


MAIN (){
    printf "\n"
    func_test_xwin
    func_test_py3
    func_test_regpy
    printf "\n"
}


MAIN
exit 0