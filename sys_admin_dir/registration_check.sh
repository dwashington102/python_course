#!/usr/bin/bash

func_test_xwin (){
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
    command -v python3 &>/dev/null
    if [ $? == 0 ]; then
        printf "\nPython3 is installed"
    else
        printf "\nPython3 is not installed"
        printf "DEBUG >>> Testing for python2"
        func_test_py2
    fi
    printf "\n"
}

func_test_py2 (){
# Confirm if python2 is installed on the server
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
    IBMREG=/opt/ibm/reregister/reregister.py
    if [ -f "$IBMREG" ]; then
        if [ -s "$IBMREG" ]; then
            printf "\nreregister.py is valid"
        else
            printf "\nreregister.py is invalid"
            printf "\nInstall latest version of ibm-anaconda pkg"
            exit 0
        fi
    else
        printf "\nreregister.py does not exists"
        printf "\nInstall latest version of ibm-anaconda pkg"
    fi
    printf "\n"
}


MAIN (){
    func_test_xwin
    func_test_py3
    func_test_regpy
    printf "\n"
}


MAIN
exit 0