#!/bin/sh 

# Script run on startup to pull git projects.

# Set variables
pythonCourse=$HOME/GIT_REPO/python_course
dotfiles=$HOME/GIT_REPO/dotfiles
timeStamp=`date +%Y%m%d%H%M`
currDir=$HOME/GIT_REPO

function print_spacer (){
	printf "\n\n\n"
}


function pull_pythoncourse (){
	    printf "git clone attempt for $pythonCourse\n"
	    git clone https://github.com/dwashington102/python_course
	    if [[ $? != 0 ]]; then
		    printf "git clone attempted, but failed for $pythonCourse\n"
	    else
		    printf "git clone succeeded for $pythonCourse\n"
        fi
}


function pull_dotfiles (){
	    printf "git clone attempt for $dotfiles\n"
	    git clone https://github.com/dwashington102/dotfiles
	    if [[ $? != 0 ]]; then
		    printf "git clone attempted, but failed for $dotfiles\n"
	    else
		    printf "git clone succeeded for $dotfiles\n"
        fi
}


function rename_pythoncourse (){
	cd $currDir
	mv $pythonCourse $pythonCourse.$timeStamp
	if [[ $? != 0 ]]; then
	    printf "$pythonCourse NOT COPIED\n"
	    printf "No git clone will be attempted for $pythonCourse\n"
	else
		pull_pythoncourse
    fi
}


function rename_dotfiles (){
	cd $currDir
	mv $dotfiles $dotfiles.$timeStamp
	if [[ $? != 0 ]]; then
	    printf "$dotfiles NOT COPIED\n"
	    printf "No git clone will be attempted for $dotfiles\n"
	else
        pull_dotfiles
    fi
}


function check_pythoncourse (){
	if [ -d "$pythonCourse" ]; then
		rename_pythoncourse
    else
	    pull_pythoncourse
    fi
}


function check_dotfiles (){
	if [ -d "$dotfiles" ]; then
		rename_dotfiles
	else
		pull_dotfiles
    fi
}


function MAIN (){
check_pythoncourse
print_spacer
check_dotfiles
}


# Where the magic happens
MAIN
printf "git pull actions completed\n"
exit 0