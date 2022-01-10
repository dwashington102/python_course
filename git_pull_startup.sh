#!/bin/sh 
# Version 0.0.4

# Script run on startup to pull git projects.

# 01-10-2022:  Updated func_check_pythoncourse to check/confirm git updates are not pending
# 07-11-2021:  Added func_pull_Docker_build
# 05-02-2021:  Added func_pull_zsh_syntax  

# Set variables
timeStamp=$(date +%Y%m%d_%H%M)
GITDIR=$HOME/GIT_REPO

# git repo directories
pythonCourse=$GITDIR/python_course
dotfiles=$GITDIR/dotfiles
zshdir=$GITDIR/zsh-syntax-highlighting
dockerBuild=$GITDIR/Docker_build

func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    boldoff=$(tput sgr0)
	reverse=$(tput rev)
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


####################### Remove 30day dir Function
# Function will remove all directories from $GITDIR older than 20days
# Directory name will include the timestamp "*202*"
func_remove_20day_dirs (){
	IFS=$'\n'
	cd $GITDIR
	listDirs=($(find . -maxdepth 1 -mtime +20 -name "*202*" -type d))
	if [[ ${#listDirs[@]} -ne 0 ]]; then
	for dirName in ${listDirs[*]}
	do
		printf "\n>>> Remove dir: ${dirName}"
		sleep 2
               rm -rf ${dirName}
		if [[ $? == 0 ]]; then
			printf "${green}"
			printf "\nDeleted Directory ${dirName} succcessful"
			printf "${normal}"
			sleep 1
		else
			printf "${red}"
			printf "\nDeleted Directory ${dirName} FAILED"
			printf "${normal}"
		fi
	printf "\n"
	done
	else
		printf "\nNo directories older than 20 days found"
	fi
}


########################## ZSHSYNTAX Functions
# Functions does a git clone for repo: https://github.com/zsh-users/zsh-syntax-highlighting.git
# Used by the zsh shell
func_check_zshsyntax () {
	if [ -d "$zshdir" ]; then
	    func_rename_zshsyntax
	else
		func_pull_zshsyntax
	fi

}

func_rename_zshsyntax (){
	cd $GITDIR
	mv $zshdir $zshdir.$timeStamp	
	if [[ $? != 0 ]]; then
	    printf "${red}"
		printf "$zshdir NOT COPIED\n"
		printf "No git clone will be attempted"
	else
	    func_pull_zshsyntax
	fi
}

func_pull_zshsyntax (){
    printf "${green}"
    printf "git clone attempt for $zshdir\n"
    printf "${normal}"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
        if [[ $? != 0 ]]; then
        	printf "${red}"
        	printf "git clone attempted, but failed for $zshdir\n"
        	printf "${normal}"
        else
        	printf "${green}"
        	printf "git clone succeeded for $zshdir\n"
        	printf "${normal}"
        fi
}

########################## Python Course Functions
# Functions does a git clone for repo: https://github.com/dwashington102/python_course
# The majority of scripts used on a daily basis are stored here

func_check_pythoncourse (){
	printf "\n"
	if [ -d "$pythonCourse" ]; then
		cd "$pythonCourse"
		git status . | grep 'working tree clean' &>/dev/null
		if [ $? == 0 ]; then
			printf "git status did not detect any uncommitted changes...creating backup of local repo directory and pulling repo from github"
		    func_rename_pythoncourse
		else
	        func_pull_pythoncourse
		fi
	else
		printf '\ngit status indicates "$pythonCourse" has uncommited changes'
    fi
	printf "\n"
}

func_rename_pythoncourse (){
	cd $GITDIR
    mv $pythonCourse $pythonCourse.$timeStamp
    if [[ $? != 0 ]]; then
    	printf "$pythonCourse NOT COPIED\n"
    	printf "No git clone will be attempted for $pythonCourse\n"
    else
    	func_pull_pythoncourse
     fi
}

func_pull_pythoncourse (){
	cd $GITDIR
	printf "${green}"
	printf "git clone attempt for $pythonCourse\n"
	printf "${normal}"
	git clone https://github.com/dwashington102/python_course
	if [[ $? != 0 ]]; then
		printf "${red}"
		printf "git clone attempted, but failed for $pythonCourse\n"
		printf "${normal}"
	else
		printf "${green}"
		printf "git clone succeeded for $pythonCourse\n"
		printf "${normal}"
    fi
}


########################## Dot Files Functions
# Functions does a git clone for repo: https://github.com/dwashington102/dotfiles
# Private registry requries "gh clone" along with private API key
# Used for various $HOME dotfiles (.vimrc, .inputrc, .zshrc...)

func_check_dotfiles (){
	if [ -d "$dotfiles" ]; then
		func_rename_dotfiles
	else
		func_pull_dotfiles
    fi
}


func_rename_dotfiles (){
	cd $GITDIR
    mv $dotfiles $dotfiles.$timeStamp
    if [[ $? != 0 ]]; then
    	printf "$dotfiles NOT COPIED\n"
    	printf "No git clone will be attempted for $dotfiles\n"
    else
        func_pull_dotfiles
    fi
}

func_pull_dotfiles (){
	printf "${green}"
	printf "git clone attempt for $dotfiles\n"
	printf "${normal}"
	gh repo clone dwashington102/dotfiles
	if [[ $? != 0 ]]; then
		printf "${red}"
		printf "git clone attempted, but failed for $dotfiles\n"
		printf "${normal}"
	else
		printf "${green}"
		printf "git clone succeeded for $dotfiles\n"
		printf "${normal}"
    fi
}


########################## Docker Build Functions

func_rename_dockerbuild (){
	cd $GITDIR
	if [ -d $dockerBuild ]; then
    	mv $dockerBuild $dockerBuild.$timeStamp
    	if [[ $? != 0 ]]; then
    	    printf "$dockerBuild NOT COPIED\n"
    	    printf "No git clone will be attempted for $dockerBuild"
    	else
    	    func_pull_dockerbuild
    	fi
	else
    	func_pull_dockerbuild
	fi
}

func_pull_dockerbuild (){
	printf "${green}"
	printf "git clone attempt for $dockerBuild\n"
	printf "${normal}"
	git clone https://github.com/dwashington102/Docker_build
	if [[ $? != 0 ]]; then
		printf "${red}"
		printf "git clone attempted, but failed for $dockerBuild\n"
		printf "${normal}"
	else
		printf "${green}"
		printf "git clone succeeded for $dockerBuild\n"
		printf "${normal}"
    fi
}

##################### Check GITHUB Connection Functions
#Function confirms a valid network connection to github.  If not network is avaiable, 
#no need to continue

func_check_conn_github () {
    wget -q --spider www.github.com
    if [ $? -ne 0 ]; then
	printf "${red}"
        printf "\nNetwork connection to github cannot be established."
	printf "\nCheck network connection...exiting"
	func_print_spacer
	printf "${normal}"
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

    func_check_pythoncourse
    func_print_spacer
    
    func_check_zshsyntax
    func_print_spacer
    
    func_check_dotfiles
    func_print_spacer
    
    func_rename_dockerbuild
    func_print_spacer
    
    func_remove_20day_dirs
}



# Where the magic happens
MAIN
printf "${yellow}"
printf "${reverse}"
printf "\ngit pull actions completed\n"
printf "${normal}"
exit 0
