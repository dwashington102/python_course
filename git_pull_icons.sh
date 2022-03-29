#!/bin/sh

tStamp=$(date +%Y%m%d_%H%M)
logfile=$HOME/cronlogs/cronlog_"$tStamp"
declare -a gitRepoList=("https://github.com/bikass/kora" "/-/-branch Arc-ICONS --single-branch  https://github.com/rtlewis88/rtl88-Themes.git" "https://github.com/unc926/OSX_ONE" "https://github.com/zayronxio/Mkos-Big-Sur" "https://github.com/yeyushengfan258/We10X-icon-theme" "https://github.com/yeyushengfan258/Win10Sur-icon-theme.git")

git_clone_actions () {
    pushd $HOME/git_icons &>/dev/null
    IFS=$'\n'
    for gitRepo in "${gitRepoList[@]}"
    do
        echo "DEBUG >>> $gitRepo"
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

