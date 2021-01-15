#!/bin/sh 
# 2021-01-06
# Script runs on startup to pull git projects.

# Set variables
GITDIR=$HOME/GIT_REPO
pythonCourse=$HOME/GIT_REPO/python_course
dotfiles=$HOME/GIT_REPO/dotfiles
timeStamp=`date +%Y%m%d_%H%M`
currDir=$HOME/GIT_REPO

# Just a spacer to format the output
function print_spacer (){
	printf "\n\n\n"
}

# Function removes copies of the older python_course and dotfiles directory
function remove_30day_dirs (){
	cd  $GITDIR
	for myDirs in `find . -maxdepth 1 -mtime +5  -name "*202*" -type  d`
	    do
                printf "${mydirs}"
                rm -f "\nMyFile: ${myDirs}"
	    done
}


#Function pulls the GIT repo python_course
function pull_pythoncourse (){
	    printf "git clone attempt for $pythonCourse\n"
	    git clone https://github.com/dwashington102/python_course
	    if [[ $? != 0 ]]; then
		    printf "git clone attempted, but failed for $pythonCourse\n"
	    else
		    printf "git clone succeeded for $pythonCourse\n"
        fi
}


#Function pulls the GIT repo dotfiles
function pull_dotfiles (){
	    printf "git clone attempt for $dotfiles\n"
	    git clone https://github.com/dwashington102/dotfiles
	    if [[ $? != 0 ]]; then
		    printf "git clone attempted, but failed for $dotfiles\n"
	    else
		    printf "git clone succeeded for $dotfiles\n"
        fi
}


#Function renames the existing python_course directory on the local server
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


#Function renames the existing python_course directory on the local server
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


# Checks if GIT_REPO/python_course exists
# If the directory exits, rename the current directory before pulling from Github
function check_pythoncourse (){
	if [ -d "$pythonCourse" ]; then
		rename_pythoncourse
    else
	    pull_pythoncourse
    fi
}


# Checks if GIT_REPO/dotfiles exists
# If the directory exits, rename the current directory before pulling from Github
function check_dotfiles (){
	if [ -d "$dotfiles" ]; then
		rename_dotfiles
	else
		pull_dotfiles
    fi
}


function MAIN (){
cd $GITDIR
check_pythoncourse
print_spacer
check_dotfiles
remove_30day_dirs
}


# Where the magic happens
MAIN
printf "\ngit pull actions completed\n"
exit 0
