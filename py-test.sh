#!/usr/bin/bash


# Is python installed

func_test_py (){
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


MAIN (){
    printf "\n"
    func_test_py
    printf "\n"
}

MAIN
exit 0