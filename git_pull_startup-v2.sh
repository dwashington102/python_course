#!/usr/bin/bash

:<<"COMMENT"
02-05-2023: Rework script


EXIT Codes:
100 : func_check_conn_github() - Connection to github down
101 : main() - Failed to create ARCHIVEDIR
102 : main() - Failed to cd to GITDIR
COMMENT

# Declare variables
timestamp=$(date +%Y%m%d_%H%M)

# Top-level directories 
GITDIR=$HOME/GIT_REPO
ARCHIVEDIR=$GITDIR/archived

# git repo directories
sysadmin=$GITDIR/sysadmin
pythonCourse=$GITDIR/python_course
dotfiles=$GITDIR/dotfiles
zshdir=$GITDIR/zsh-syntax-highlighting
dockerBuild=$GITDIR/Docker_build

declare -a localdirs=("${sysadmin}" "${pythonCourse}" "${dotfiles}" "${zshdir}" "${dockerBuild}")


function func_set_colors ()
{
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


function func_print_spacer ()
{
    printf "${normal}"
    printf "\n\n\n"
}


function func_check_conn_github ()
{
    wget -q --spider www.github.com
    if [ $? -ne 0 ]; then
        printf "${red}"
        printf "\nNetwork connection to github cannot be established.\n"
        printf "Check network connection...exit(100)\n"
        printf "${normal}"
        exit 100
    fi

    printf "${green}"
    printf "Successful connection to Github confirmed\n"
    func_print_spacer
    printf "${normal}"
}


function func_copy_dir ()
{
    printf "${yellow}"
    printf "Rename existing ${localdir}\n"
    printf "${normal}"
    sleep 2
    /bin/mv $localdir $localdir.$timestamp &>/dev/null
    if [[ $? -ne 0 ]]; then
        printf "${red}"
        printf "Copy for ${localdir} FAILED\n"
        printf "${normal}"
    fi
    /bin/mv -v $localdir.$timestamp $ARCHIVEDIR/.
    sleep 2
}


function func_pull_repo() 
{
    if [[ "$PWD" != "$GITDIR" ]]; then
        printf "${red}"
        printf "WRONG DIRECTORY STOP\n"
        sleep 10
        printf "${normal}"
    fi
    printf "${green}"
    printf "git clone attempt for ${localdir}\n"
    sleep 1
    printf "${normal}"
    if [[ "${localdir}" == "${sysadmin}" ]]; then
        git clone https://github.com/dwashington102/sysadmin
    elif [[ "${localdir}" == "${pythonCourse}" ]]; then
        git clone https://github.com/dwashington102/python_course
    elif [[ "${localdir}" == "${dotfiles}" ]]; then
        gh repo clone dwashington102/dotfiles
    elif [[ "${localdir}" == "${zshdir}" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    elif [[ "$localdir" == "${dockerBuild}" ]]; then
        git clone https://github.com/dwashington102/Docker_build
    else
       printf "${red}"
       printf "${localdir} not currently in GITDIR\n"
       printf "${normal}"
    fi
}


function func_remove_old_dirs ()
{
    pushd $GITDIR/archived
    IFS=$'\n'
    listDirs=($(find . -maxdepth 1 -mtime +10 -type d -regextype posix-extended -regex '.*202[[:digit:]].*_[[:digit:]]{3,}$'))
    if [[ ${#listDirs[*]} -ne 0 ]]; then
    for dirName in ${listDirs[*]}
    do
        printf "\n"
        printf ">>> Remove archive dir: ${dirName}\n"        
        sleep 2
        rm -rf ${dirName}
        if [[ $? == 0 ]]; then
            printf "${green}"
            printf "\n"
            printf "Deleted Directory ${dirName} succcessful\n"
            printf "${normal}"
            sleep 1
        else
            printf "${red}"
            printf "\n"
            printf "Deleted Directory ${dirName} FAILED\n"
            printf "${normal}"
        fi
    printf "\n"
    done
    else
        printf "\n"
        printf "No directories older than 10 days found\n"
    fi
}


main ()
{
    pushd $GITDIR &>/dev/null
    if [[ $? -ne 0 ]]; then
        printf "${red}"
        printf "Failed to cd to GITDIR...exit(102)\n"
        printf "${normal}"
        exit 102
    fi

    if [ ! -d $ARCHIVEDIR ]; then
        /usr/bin/mkdir -p $ARCHIVEDIR
        if [[ $? -ne 0 ]]; then
            printf "Failed to create ARCHIVEDIR...exit(101)\n"
            exit 101
        fi
    fi

    if [[ "$TERM" != "dumb" ]]; then
        func_set_colors
    fi

    func_check_conn_github

    for localdir in ${localdirs[@]}
        do
        printf "\n"
        if [ -d "${localdir}" ]; then
            pushd "${localdir}" &>/dev/null
            gitstatus=$(git status -s | wc -l)
            if [[ ${gitstatus} -eq 0 ]]; then
                # Adding popd to return to GITDIR before copy and clone
                popd &>/dev/null
                func_copy_dir
                func_pull_repo
            else
                printf "${bold}${cyan}"
                printf "git status indicates ${localdir} has uncommited changes\n"
                printf "${normal}"
                # Returning to GITDIR because no actions will take place in current dir
                popd &>/dev/null
            fi
        else
            printf "${yellow}"
            printf "Existing ${localdir} not found in local repo...building repo now\n"
            printf "${normal}"
            sleep 2
            # No need to popd since current directory is GITDIR
            func_pull_repo
        fi
        done
    func_remove_old_dirs
}


main
printf "${yellow}"
printf "${reverse}"
printf "\ngit pull actions completed${normal}\n"
