#!/bin/sh 
# Version 0.0.3

# Script run on startup to pull git projects.

# 05-02-2021:  Added func_pull_zsh_syntax  

# Set variables
GITDIR=$HOME/GIT_REPO
pythonCourse=$HOME/GIT_REPO/python_course
dotfiles=$HOME/GIT_REPO/dotfiles
zshdir=$GITDIR/zsh-syntax-highlighting
timeStamp=`date +%Y%m%d_%H%M`


func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    boldoff=$(tput sgr0)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
    boldoff=$(tput sgr0)
}

func_print_spacer (){
	printf "${normal}"
	printf "\n\n\n"
}

func_remove_30day_dirs (){
	printf "\nDEBUG >>> Entered func_remove_30day_dirs()"
	cd  $GITDIR
	for myDirs in `find . -maxdepth 1 -mtime +30  -name "*202*" -type  d`
	    do
		printf "\nDEBUG >>> entered for loop"
                printf "${mydirs}"
                rm -f "\nMyFile: ${myDirs}"
	    done
}

function func_pull_zsh_syntax {
	cd $GITDIR
	mv $zshdir $zshdir.$timeStamp
	if [[ $? != 0 ]]; then
	    printf "$zshdir NOT COPIED\n"
	    printf "No git clone will be attempted for $zshdir\n"
	else
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    fi
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
	cd $GITDIR
	mv $pythonCourse $pythonCourse.$timeStamp
	if [[ $? != 0 ]]; then
	    printf "$pythonCourse NOT COPIED\n"
	    printf "No git clone will be attempted for $pythonCourse\n"
	else
		pull_pythoncourse
    fi
}


function rename_dotfiles (){
	cd $GITDIR
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

func_check_conn_github () {
    wget -q --spider www.github.com
    if [ $? -ne 0 ]; then
	printf "${red}"
        printf "\nNetwork connection to github cannot be established."
	printf "\nCheck network connection...exiting"
	func_print_spacer
	exit 100
    else
	printf "${green}"
        printf "\nConnection to Github confirmed"
		func_print_spacer
	printf "${normal}"
    fi
}

function MAIN (){
func_set_colors
func_check_conn_github
cd $GITDIR
check_pythoncourse
func_print_spacer
func_pull_zsh_syntax
func_print_spacer
check_dotfiles
func_print_spacer
printf "\nDEBUG >>> are we calling func_remove_30day_dirs?"
func_remove_30day_dirs
}



# Where the magic happens
MAIN
printf "\ngit pull actions completed\n"
exit 0
