#!/bin/sh 
# Version 0.0.7

# Script run on startup to pull git projects.

:<<"COMMENT"
01-17-2023: Added ARCHIVEDIR
11-03-2022: Changed "git status" to use "git diff"
07-27-2022: Added sysadmin repo
03-21-2022: Updated regex find statement 
03-04-2022: Updated listdirs adding regex to find command
02-06-2022: Changed retention from from 20 days to 10 days
01-10-2022: Updated func_check_pythoncourse to check/confirm git updates are not pending
07-11-2021: Added func_pull_Docker_build
05-02-2021: Added func_pull_zsh_syntax  


EXIT Codes:
100 : func_check_conn_github() - Connection to github down
101 : MAIN() - Failed to create ARCHIVEDIR
COMMENT

# Set variables
timeStamp=$(date +%Y%m%d_%H%M)
GITDIR=$HOME/GIT_REPO

# git repo directories
sysadmin=$GITDIR/sysadmin
pythonCourse=$GITDIR/python_course
dotfiles=$GITDIR/dotfiles
zshdir=$GITDIR/zsh-syntax-highlighting
dockerBuild=$GITDIR/Docker_build

func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}

func_print_spacer (){
    printf "${normal}"
    printf "\n\n\n"
}


####################### Remove 10day dir Function
# Function will remove all directories from $GITDIR older than 20days
# Directory name will include the timestamp "*202*"
func_remove_old_dirs (){
    IFS=$'\n'
    #cd $GITDIR
    pushd $ARCHIVEDIR &>/dev/null
    listDirs=$(find . -maxdepth 1 -mtime +10 -type d -regextype posix-extended -regex '.*202[[:digit:]].*_[[:digit:]]{3,}$')
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
    mv $zshdir $zshdir.$timeStamp && mv $zshdir.$timeStamp $ARCHIVEDIR/.
    #mv $zshdir $ARCHIVEDIR/$zshdir.$timeStamp   
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
        pushd "$pythonCourse" &>/dev/null
        #git status . | grep 'working tree clean' &>/dev/null
        git diff --exit-code &>/dev/null
        if [ $? == 0 ]; then
            printf "git status did not detect any uncommitted changes...creating backup of local repo directory and pulling repo from github\n"
            func_rename_pythoncourse
        else
            printf '\ngit status indicates pythonCourse has uncommited changes'
        fi
    else
        func_pull_pythoncourse
    fi
    printf "\n"
}

func_rename_pythoncourse (){
    pushd $GITDIR &>/dev/null
    mv $pythonCourse $pythonCourse.$timeStamp && mv $pythonCourse.$timeStamp $ARCHIVEDIR/.
    #mv $pythonCourse $ARCHIVEDIR/$pythonCourse.$timeStamp
    if [[ $? != 0 ]]; then
        printf "${red}"
        printf "$pythonCourse NOT COPIED\n"
        printf "No git clone will be attempted for $pythonCourse\n"
        printf "${normal}"
    else
        func_pull_pythoncourse
     fi
}

func_pull_pythoncourse (){
    pushd $GITDIR &>/dev/null
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

func_check_sysadmin (){
    printf "\n"
    if [ -d "$sysadmin" ]; then
        pushd "$sysadmin" &>/dev/null
        #git status . | grep 'working tree clean' &>/dev/null
        git diff --exit-code &>/dev/null
        if [ $? == 0 ]; then
            printf "git status did not detect any uncommitted changes...creating backup of local repo directory and pulling repo from github\n"
            func_rename_sysadmin
        else
            printf '\ngit status indicates sysadmin has uncommited changes'
        fi
    else
        func_pull_sysadmin
    fi
    printf "\n"
}


func_rename_sysadmin (){
    cd $GITDIR
    #mv $sysadmin $ARCHIVEDIR/$sysadmin.$timeStamp
    mv $sysadmin $sysadmin.$timeStamp && mv $sysadmin.$timeStamp $ARCHIVEDIR/.
    if [[ $? != 0 ]]; then
        printf "${red}"
        printf "$sysadmin NOT COPIED\n"
        printf "No git clone will be attempted for $sysadmin\n"
        printf "${normal}"
    else
        func_pull_sysadmin
     fi
}

func_pull_sysadmin (){
    cd $GITDIR
    printf "${green}"
    printf "git clone attempt for $sysadmin\n"
    printf "${normal}"
    git clone https://github.com/dwashington102/sysadmin
    if [[ $? != 0 ]]; then
        printf "${red}"
        printf "git clone attempted, but failed for $sysadmin\n"
        printf "${normal}"
    else
        printf "${green}"
        printf "git clone succeeded for $sysadmin\n"
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
    #mv $dotfiles $ARCHIVEDIR/$dotfiles.$timeStamp
    mv $dotfiles $dotfiles.$timeStamp && mv $dotfiles.$timeStamp $ARCHIVEDIR/.
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
        mv $dockerBuild $dockerBuild.$timeStamp && mv $dockerBuild.$timeStamp $ARCHIVEDIR/.
        #mv $dockerBuild $ARCHIVEDIR/$dockerBuild.$timeStamp
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
    ARCHIVEDIR="$GITDIR/archived"
    if [ ! -d $ARCHIVEDIR ]; then
        /usr/bin/mkdir $ARCHIVEDIR
        if [ "$?" != "0" ]; then
            printf "\nFailed to create ARCHIVEDIR...exit(101)"
            exit 101
        fi
    fi

    #func_set_colors
    #2022-01-13: Replaced func_set_colors with if clause below in order to avoid tput command from dumping errors to console when running script against remote computer.
    if [ $TERM != "dumb" ]; then
        bold=$(tput bold)
        blink=$(tput blink)
        offall=$(tput sgr0)
        reverse=$(tput rev)
        red=$(tput setaf 1)
        green=$(tput setaf 2)
        yellow=$(tput setaf 3)
        cyan=$(tput setaf 6)
        normal=$(tput setaf 9)
    fi
    func_check_conn_github

    cd $GITDIR

    func_check_zshsyntax
    func_print_spacer
    
    func_check_dotfiles
    func_print_spacer
    
    func_rename_dockerbuild
    func_print_spacer
    
    func_check_pythoncourse
    func_print_spacer

    func_check_sysadmin
    func_print_spacer
    
    func_remove_old_dirs
}

# Where the magic happens
MAIN
printf "${yellow}"
printf "${reverse}"
printf "\ngit pull actions completed\n"
printf "${normal}"
