#!/usr/bin/sh
# 2022-03-29

:<< 'COMMENT'
Script performs a 'git clone' of various repos that contains icons used on the workstation
allows user to automate the process of keeping icons updated with the latest version
COMMENT


tStamp=$(date +%Y%m%d_%H%M)
scriptName=`basename "$0"`
logfile=$HOME/cronlogs/cronlog-"$scriptName"_"$tStamp"
declare -a gitRepoList=("https://github.com/bikass/kora" "/-/-branch Arc-ICONS --single-branch  https://github.com/rtlewis88/rtl88-Themes.git" "https://github.com/unc926/OSX_ONE" "https://github.com/zayronxio/Mkos-Big-Sur" "https://github.com/yeyushengfan258/We10X-icon-theme" "https://github.com/yeyushengfan258/Win10Sur-icon-theme.git")

git_clone_actions () {
    pushd $HOME/git_icons &>/dev/null
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
    git_clone_actions
    ) >> "$logfile"
}


MAIN
exit 0

