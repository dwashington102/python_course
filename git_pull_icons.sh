#!/usr/bin/sh
# 2022-03-29

<< 'COMMENT'
Script performs a 'git clone' of various repos that contains icons used on the workstation
allows user to automate the process of keeping icons updated with the latest version


EXIT CODES:
1 - No existing git repo directories found in $HOME/git_icons
COMMENT

tStamp=$(date +%Y%m%d_%H%M)
scriptName=`basename "$0"`
logfile=$HOME/cronlogs/cronlog-"$scriptName"_"$tStamp".log
declare -a gitRepoList=("https://github.com/vinceliuice/Fluent-icon-theme.git"
 "https://github.com/alvatip/Nordzy-icon.git"
 "https://github.com/bikass/kora"
 "/-/-branch Arc-ICONS --single-branch  https://github.com/rtlewis88/rtl88-Themes.git" 
 "https://github.com/unc926/OSX_ONE" 
 "https://github.com/zayronxio/Mkos-Big-Sur" 
 "https://github.com/yeyushengfan258/We10X-icon-theme" 
 "https://github.com/yeyushengfan258/Win10Sur-icon-theme.git")

rename_dirs (){
     IFS=$'\n'
     list_dirs=($(find . -maxdepth 1 ! -iname ".*" -type d -exec basename {} \;))
     if [ "${#list_dirs[@]}" -ne "0" ]; then
         for dirName in "${list_dirs[@]}"
         do
             printf "\nDir to rename - %s\n" "$dirName"
             mv "$dirName" "$dirName"_"$tStamp" 
         done
      else
              printf "\nNO Directories found...exiting 1"
              exit 1 

       fi
}

git_clone_actions () {
    IFS=$'\n'
    for gitRepo in "${gitRepoList[@]}"
    do
	    git clone "$gitRepo" &>>"$logfile"
	    printf "git '$gitRepo' rc=$?\n\n"
    done
}

MAIN (){
    if [ ! -d "$HOME"/cronlogs ]; then
        mkdir -p "$HOME"/cronlogs
    fi
    
    if [ ! -f "$logfile" ]; then
	touch "$logfile"
    fi

    (
    pushd $HOME/git_icons &>/dev/null
    rename_dirs
    git_clone_actions
    printf "\nActions Completed at $(date +%Y%m%d_%H:%M)\n"
    ) > "$logfile"
}

MAIN
