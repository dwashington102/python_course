#!/bin/bash -x

:<<'COMMENTS'
Script removes files related to browser history, cache,
command line history, and etc.

exit codes:
101: bleachbit application not found
102: unable to create log file

COMMENTS

# Common functions
create_log() {
    logdir="/var/log/custom"
    dts=$(date +"%Y%m%d_%H%M%S")

    if [ ! -d ${logdir} ]; then
        /usr/bin/mkdir -p ${logdir} &>/dev/null
    fi

    if [ -d "${logdir}" ]; then
        logfile="${logdir}/clear_cache_${dts}.log"
    else
        logfile="$HOME/clear_cache_${dts}.log"
    fi

    # Create log file
    if ! /usr/bin/truncate -s0 "${logfile}"; then
        printf "Unable to creae log file %s...exit(102)" "${logfile}"
        exit 102
    fi
}


log_message(){
    local message
    message="$1"
    printf "%s: $message\n" "$(date --rfc-3339=seconds)" >> ${logfile}
}
# End Common functions

func_check_bleachbit (){
    log_message "${FUNCNAME[0]}()"
    get_bleachbit_ver=$(bleachbit --version 2>/dev/null | command grep -E ^'Bleach.*version')
    if [ -n "$get_bleachbit_ver" ]; then
        log_message "\tVersion Info:\n %s" "$get_bleachbit_ver"
    else
        printf "Bleachbit application not found...exit(101)\n" | tee --append "${logfile}"
        exit 101
    fi
}

# This function is used to remove all entries from the "Recent Files" of file manager
func_clear_files_recent (){
    log_message "${FUNCNAME[0]}()"

    s_str="bookmark href"
    recentdocs="$HOME/.local/share/recently-used.xbel"

    if [ -f "${recentdocs}" ]  && grep --quiet -m1 "${s_str}" "${recentdocs}" ; then
        log_message "\tRemoving recent docs"
cat << EOF > "${recentdocs}".new
<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0" xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks" xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info">
</xbel>
EOF

        cp --verbose "${recentdocs}" "${recentdocs}".OKTODELETE
        cp --verbose "${recentdocs}".new "${recentdocs}"
    else
        log_message "\tResults: %s does not exist." "${recentdocs}"
    fi

    # Used for legacy systems 
    recent_docdir="$HOME/.local/share/RecentDocuments"
    if [[ -d "${recent_docdir}" ]]; then
        IFS=$'\n'
        ar_recentdoc=( $(find "$recent_docdir" -mindepth 1 -maxdepth 1 -type f))
        for fname in "${ar_recentdoc[@]}"
        do
            /usr/bin/truncate --size=0 "${fname}"
            log_message "\tTruncate file: %s rc=$?\n" "${fname}"
            bleachbit -s "${fname}"
        done
    fi
}


func_delete_history (){
    log_message "${FUNCNAME[0]}()"
    u_shell=$(basename "$SHELL")
    mp4_str="mp4"

    if [[ "${u_shell}" == "zsh" ]]; then
        log_message "\tSHELL: ($u_shell)"
        sed -i '/${mp4_str}/d' $HOME/.zsh_history
    elif [ "${u_shell}" == "bash" ]; then
        log_message "\tSHELL: ($u_shell)"
        for ln in $(history | grep ${mp4_str} \
        | awk '{print $1}' | sort -nr)
            do
                history -d ${ln}    
            done
    else
        log_message "\tSHELL UNKNOWN"
        log_message "\tSHELL: ($u_shell)"
        log_message "\tUnable to clear shell history"
    fi
}


kde_recentdb (){
    log_message "${FUNCNAME[0]}()"
    sqlitedb="${HOME}/.local/share/kactivitymanagerd/resources/database"
    [ -f "${sqlitedb}" ] && log_message "KDE RecentFiles DB Found" && truncate -s0 ${sqlitedb} ; log_message "action rc=$?" ||: 
}

func_msedge (){
    log_message "${FUNCNAME[0]}()"
    declare -a msdirs=("")
    msdirs=$(command find /home -type d | command grep "\/.config/microsoft-edge" | awk -F'[//]' '{print $5}' | sort -u)
    if [[ "${#msdirs[@]}" -gt 0 ]]; then
        log_message "msdirs: ${#msdirs[@]} found\n"
    fi
}

# Function runs all browser cleaners
func_browser_cleaner (){
    log_message "${FUNCNAME[0]}()"
    IFS=$'\n'
    get_pids=($(ps auxh))
    get_chrome_pid=$(echo "${get_pids[*]}" | grep -E '/google.*/chrome')
    get_brave_pid=$(echo "${get_pids[*]}" | grep -E '/bin/brave')
    get_ff_pid=$(echo "${get_pids[*]}" | grep -E '/bin/firefox')
    get_opera_pid=$(echo "${get_pids[*]}" | grep -E '/opera.*/opera')
    get_msedge_pid=$(echo "${get_pids[*]}" | grep -E '/microsoft/msedge')

    if [ -z "$get_chrome_pid" ]; then
        log_message "\tChrome PID not found...running cleaners"
        for cleaner in $(bleachbit -l 2>/dev/null | command grep -E ^'google_chrome.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\tRan browser cleaner for Chrome"
    else
        log_message "\tRunning Chrome process detected...skipping cleanup"
    fi

    if [ -z "$get_opera_pid" ]; then
        log_message "\tOpera PID not found...running cleaners"
        for cleaner in $(bleachbit -l  2>/dev/null | command grep -E ^'opera.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\tRan browser cleaner for Opera"
    else
        log_message "\tRunning Opera process detected...skipping cleanup"
    fi

    if [ -z "$get_brave_pid" ]; then
        log_message "\tBrave PID not found...running cleaners"
        for cleaner in $(bleachbit -l 2>/dev/null | command grep -E ^'brave.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\tRan browser cleaner for Brave"
    else
        log_message "\tRunning Brave process detected...skipping cleanup"
    fi

    if [ -z "$get_ff_pid" ]; then
        log_message "\tFirefox PID not found...running cleaners"
        for cleaner in $(bleachbit -l 2>/dev/null | command grep -E ^'firefox.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\tRan browser cleaner for Firefox"
    else
        log_message "\tRunning Firefox process detected...skipping cleanup"
    fi

    if [ -z "$get_msedge_pid" ]; then
        log_message "\tMS-Edge PID not found...running cleaners"
        for cleaner in $(bleachbit -l 2>/dev/null | command grep -E ^'microsoft_edge.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\tRan browser cleaner for MS-Edge"
    else
        log_message "\tRunning MS-Edge process detected...skipping cleanup"
    fi
}
        

func_trash_empty (){
    log_message "${FUNCNAME[0]}()"
    trash-empty -f 3 &>/dev/null
    date +%H:%M:%S
    printf "$FUNCNAME rc=$?\n" 
    printf "\n"
    
}

# This function removes old logs generated by cron jobs from the $HOME/cronlogs directory
func_bleachbit_cron_logs (){
    log_message "${FUNCNAME[0]}()"
    printf "\n"
    # only the printf statements in this function write to log file. Output of bleachbit command not included in log file
    printf "\nStarting ${FUNCNAME}\n"
    cd $HOME/cronlogs
    command bleachbit -so $(find . -type f -mtime +5) &>/dev/null
    printf "$FUNCNAME rc=$?\n" 
    printf "\n"
}



# Function cleans up browsers history and cookies along with MRU of vlc
func_run_bleachbit_cleaners (){
    log_message "${FUNCNAME[0]}()"
    printf "\n"
    # only the printf statements in this function write to log file. Output of bleachbit command not included in log file
    printf "\nStarting ${FUNCNAME}\n"  >> $logfile
    command bleachbit -c vlc.mru  &>/dev/null
    #command bleachbit -c system.trash firefox.cache google_chrome.cache opera.cache chromium.cache chromium.history chromium.cookies google_chrome.history vlc.mru  &>/dev/null
    printf "$FUNCNAME rc=$?\n" 
    printf "\n"
}

func_run_bleachbit_targeted (){
    log_message "${FUNCNAME[0]}()"
    printf "\n"
    # only the printf statements in this function write to log file. Output of bleachbit command not included in log file
    printf "\nStarting ${FUNCNAME}\n"  
    cd $HOME/.cache/thumbnails &>/dev/null
    command bleachbit -so $(find . -type f -name "*.png") &>/dev/null
    printf "$FUNCNAME rc=$?\n" >> $logfile
    printf "\n"
}

func_truncate_vlc_history (){
    log_message "${FUNCNAME[0]}()"
    printf "\n"
    printf "Starting ${FUNCNAME}\n"
    truncate -s 0 $HOME/.config/vlc/vlc-qt-interface.conf &>/dev/null
    printf "$FUNCNAME rc=$?\n" 
    printf "\n"
}


truncate_dragonplayerrc (){
    log_message "${FUNCNAME[0]}()"
    dp_conf="$HOME/.config/kde.org/dragonplayer.conf"

    getid=$(id -u)
    if [[ "${getid}" == 0 ]]; then
        pathdir="/home"
    else
        pathdir="$HOME"
    fi
    printf "pathdir set to: ${pathdir}\n"
    dragonlist=( $(find ${pathdir} -name dragonplayerrc -type f) )
    if [[ "${#dragonlist}" -gt 0 ]]; then
        for dragonfile in "${dragonlist[@]}"
        do
            command truncate -s 0 ${dragonfile}
            printf "File to truncate: ${dragonfile}...rc=$?\n"
        done
    fi

    if [ -f ${dp_conf} ] && grep --quiet -i "lastFolder=" "${dp_conf}"; then
        log_message "\tUpdate %s" "${dp_conf}"
        sed -i '/^lastFolder/d' "${dp_conf}"
    fi
}


clear_viminfo (){
    log_message "${FUNCNAME[0]}()"
    if [[ -f $HOME/.viminfo ]]; then
        size_before=$(ls -lth $HOME/.viminfo)
        log_message "\tTruncate: viminfo"
        /usr/bin/truncate --size=0 $HOME/.viminfo
        size_after=$(ls -lth $HOME/.viminfo)
        ls -lth $HOME/.viminfo &>>${logfile}
    fi
}


MAIN() {
# Constant Variables
create_log
log_message

if [ "${TERM}" != "dumb" ]; then
    func_check_bleachbit
    func_clear_files_recent 
    func_delete_history 
    if -x /usr/bin/trash-empty; then
        func_trash_empty 
    fi
    func_truncate_vlc_history 
    truncate_dragonplayerrc
    kde_recentdb
    func_browser_cleaner
    clear_viminfo
    exit 0
fi

#bleachbit functions should not append to $logfile here
    log_message "\tCalling bleachbit functions"
    func_bleachbit_cron_logs  
    func_run_bleachbit_cleaners
    func_run_bleachbit_targeted
}

MAIN
