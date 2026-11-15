#!/bin/bash

:<<'COMMENTS'
Script removes files related to browser history, cache,
command line history, cleans sqlite3 databases associated with browser
and etc.

exit codes:
101: bleachbit application not found
102: unable to create log file

COMMENTS

# Common functions
create_log() {
    if [[ "$(id -u)" == 0 ]]; then
        logdir="/var/log/custom"
    else
        logdir="/var/tmp/custom"
    fi

    dts=$(date +"%Y%m%d_%H%M%S")

    if [ ! -d ${logdir} ]; then
        /usr/bin/mkdir -p ${logdir} &>/dev/null
    fi

    if [ -d "${logdir}" ]; then
        logfile="${logdir}/clear_cache_${dts}.log"
    else
        logfile="$HOME/clear_cache_${dts}.log" # Fall back location
    fi

    # Create log file
    if ! /usr/bin/truncate -s0 "${logfile}"; then
        printf "Unable to create log file %s...exit(102)" "${logfile}"
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
:<<'DESCRIPTION'
This function confirms the bleachbit application is installed
DESCRIPTION
    log_message "${FUNCNAME[0]}()"
    get_bleachbit_ver=$(bleachbit --version 2>/dev/null | command grep -E ^'Bleach.*version')
    if [ -n "$get_bleachbit_ver" ]; then
        log_message "\tVersion Info: (${get_bleachbit_ver})"
    else
        printf "Bleachbit application not found...exit(101)\n" | tee --append "${logfile}"
        exit 101
    fi
}

func_clear_files_recent (){
:<<'DESCRIPTION'
This function is used to remove all entries from the "Recent Files" of file manager
DESCRIPTION
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

        cp --verbose "${recentdocs}" "${recentdocs}".OKTODELETE &>>${logfile}
        cp --verbose "${recentdocs}".new "${recentdocs}" &>>${logfile}
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
:<<'DESCRIPTION'
This function clears the shell (zsh and bash) history of mp4 file entries
DESCRIPTION
    log_message "${FUNCNAME[0]}()"
    u_shell=$(basename "$SHELL")
    mp4_str="mp4"

    if [[ "${u_shell}" == "zsh" ]]; then
        log_message "\tSHELL: ${u_shell}"
        sed -i '/${mp4_str}/d' $HOME/.zsh_history
    elif [[ "${u_shell}" == "bash" ]]; then
        log_message "\tSHELL: ${u_shell}"
        for ln in $(history | grep ${mp4_str} \
        | awk '{print $1}' | sort -nr)
            do
                history -d ${ln}    
            done
    else
        log_message "\tSHELL UNKNOWN"
        log_message "\tSHELL: ${u_shell}"
        log_message "\tUnable to clear shell history"
    fi
}


func_trash_empty (){
:<<'DESCRIPTION'
Function removes all files older than 3 days in the trash
DESCRIPTION
    log_message "${FUNCNAME[0]}()"
    trash-empty -f 3 &>/dev/null
}

func_truncate_vlc_history (){
    log_message "${FUNCNAME[0]}()"
    vlc_conf="$HOME/.config/vlc/vlc-qt-interface.conf"
    if [ -f "${vlc_conf}" ]; then
        log_message "\tProcessing vlc qt conf"
        if grep --quiet -i -E ^list= "${vlc_conf}"; then
            sed -i '/^list=/d' "${vlc_conf}"
        fi
    fi
}


func_run_vlc_cleaner (){
    log_message "${FUNCNAME[0]}()"
    command bleachbit -c vlc.mru  &>>${logfile}
    # command bleachbit -c vlc.mru  &>/dev/null
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
    log_message "\tpathdir set to: ${pathdir}"
    dragonlist=( $(find ${pathdir} -name dragonplayerrc -type f) )
    if [[ "${#dragonlist}" -gt 0 ]]; then
        for dragonfile in "${dragonlist[@]}"
        do
            command truncate -s 0 ${dragonfile}
            log_message "\tFile to truncate: ${dragonfile}...rc=$?\n"
        done
    fi

    if [ -f ${dp_conf} ] && grep --quiet -i "lastFolder=" "${dp_conf}"; then
        log_message "\tUpdate ${dp_conf}"
        sed -i '/^lastFolder/d' "${dp_conf}"
    fi
}


kde_recentdb (){
    log_message "${FUNCNAME[0]}()"
    sqlitedb="${HOME}/.local/share/kactivitymanagerd/resources/database"
    [ -f "${sqlitedb}" ] && log_message "\tKDE RecentFiles DB Found" && truncate -s0 ${sqlitedb} ; log_message "\taction rc=$?" ||: 
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
            log_message "\tCalling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\t*** Completed browser cleaner for Chrome ***"
    else
        log_message "\tRunning Chrome process detected...skipping cleanup"
    fi

    if [ -z "$get_opera_pid" ]; then
        log_message "\tOpera PID not found...running cleaners"
        # Remove contents of Sessions
        dir_session="$HOME/.config/opera/Default/Sessions"

        if [ -d "${dir_session}" ]; then
            for f_name in $(find ${dir_session} -type f)
            do
                bleachbit -so "${f_name}" &>>${logfile}
            done
        fi

        for cleaner in $(bleachbit -l  2>/dev/null | command grep -E ^'opera.')
        do
            log_message "Calling cleaner (${cleaner})"
            bleachbit -c $cleaner &>>${logfile}
        done
        log_message "\t*** Completed browser cleaner for Opera ***"
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
        log_message "\t*** Completed browser cleaner for Brave ***"
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
        log_message "\t*** Completed browser cleaner for Firefox ***"
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
        log_message "\t*** Completed browser cleaner for MS-Edge ***"
    else
        log_message "\tRunning MS-Edge process detected...skipping cleanup"
    fi
}
        

clear_viminfo (){
    log_message "${FUNCNAME[0]}()"
    if [[ -f $HOME/.viminfo ]]; then
        size_before=$(ls -lth $HOME/.viminfo)
        log_message "\tTruncate: viminfo"
        /usr/bin/truncate --size=0 $HOME/.viminfo
        size_after=$(ls -lth $HOME/.viminfo)
        log_message "\tResults:\n\t${size_after}"
    fi
}


func_run_bleachbit_thumbnails (){
    log_message "${FUNCNAME[0]}()"
    # only the printf statements in this function write to log file. Output of bleachbit command not included in log file
    if [ -d $HOME/.cache/thumbnails ]; then
        log_message "\tProcessing thumbnails..."
        search_path="$HOME/.cache/thumbnails"
        command bleachbit -so $(find "${search_path}" -type f -name "*.png") &>/dev/null
    fi
}


# Query/Clear sqlite3 databases
# func_db_clean(){
#     log_message "${FUNCNAME[0]}()"
#     db_top_sites="$HOME/.config"
#     IFS=$'\n'
#     db_names=("Top Sites" "History" "Network Action Predictor")
# 
#     tb_names_01=("top_sites") # Top Sites database
#     tb_names_02=("urls" "visited_links" "downloads" "downloads_url_chains") # History db
#     tb_names_03=("network_action_predictor") # Network Action Predictor
# 
#     for db in ${db_names}
#     do
#         for db_search in $(find ${db_top_sites} -type -f -name "${db}" | grep -E '(Brave|opera|microsoft-edge)')
#         do
#             if [[ "${db_search}" == "Top Sites" ]]; then
#                 tb_names=${tb_names_01}
#             elif [[ "${db_search}" == "History" ]]; then
#                 tb_names=${tb_names_02}
#             else
#                 tb_names=${tb_names_03}
#             fi
#         done
# 
#         log_message "dbName: -> ${db_search} -> Tables: ${tb_names[@]}"
#         for t_name in "${tb_names[@]}"
#         do
#             log_message "DEBUG>>> db_name -> ${db_search} -> t_name -> ${t_name}"
#             sqlite3 -init /dev/null "${db_name}" "select * from ${t_name}" &>>${logfile}
#         done
#     done
# }


func_db_top_sites (){
    log_message "${FUNCNAME[0]}()"
    IFS=$'\n'
    for db_name in $(find ${DB_PATH} -type f -name "Top Sites" | grep -i "${BROWSER}")
    # for db_name in $(find ${db_top_sites} -type f -name "Top Sites" | grep -E '(Brave|opera|microsoft-edge)')
    do
        top_sites_tables=("top_sites")
        for t_name in "${top_sites_tables[@]}"
        do
            # sqlite3 -init /dev/null "${db_name}" "select * from ${t_name}" &>>${logfile}
            check_table=$(sqlite3 -init /dev/null "${db_name}" "select name from sqlite_master where type='table' and name='${t_name}'")
            if [[ "${check_table}" == "${t_name}" ]]; then
                log_message "\tdelete action for ${t_name}"
                sqlite3 -init /dev/null "${db_name}" "delete from ${t_name}" &>>${logfile}
            fi
        done
    done
}

func_db_history (){
    log_message "${FUNCNAME[0]}()"
    IFS=$'\n'
    for db_name in $(find ${DB_PATH} -type f -name "History" | grep -i "${BROWSER}")
    #for db_name in $(find ${db_history} -type f -name "History" | grep -E '(Brave|opera|microsoft-edge)')
    do
        history_tables=("segments" "urls" "visited_links" "downloads" "downloads_url_chains")
        for t_name in "${history_tables[@]}"
        do
            # sqlite3 -init /dev/null "${db_name}" "select * from ${t_name}" &>>${logfile}
            check_table=$(sqlite3 -init /dev/null "${db_name}" "select name from sqlite_master where type='table' and name='${t_name}'")
            if [[ "${check_table}" == "${t_name}" ]]; then
                log_message "\tdelete action for ${t_name}"
                sqlite3 -init /dev/null "${db_name}" "delete from ${t_name}" &>>${logfile}
            fi
        done
    done
}

func_db_network_action_predictor () {
    log_message "${FUNCNAME[0]}()"
    IFS=$'\n'
    for db_name in $(find ${DB_PATH} -type f -name "Network Action Predictor" | grep -i "${BROWSER}")
    do
        network_action_tables=("network_action_predictor" "resource_prefetch_predictor_host_redirect" "resource_prefetch_predictor_origin")
        for t_name in "${network_action_tables[@]}"
        do
            if [[ "${check_table}" == "${t_name}" ]]; then
                log_message "\tdelete action for ${t_name}"
                sqlite3 -init /dev/null "${db_name}" "delete from ${t_name}" &>>${logfile}
            fi
        done
    done
}

func_db_load_statistics_db () {
    log_message "${FUNCNAME[0]}()"
    IFS=$'\n'
    for db_name in $(find ${DB_PATH} -type f -name "load_statistics.db" | grep -i "${BROWSER}")
    do
        load_statistics_db_tables=("load_statistics" "redirect_statistics")
        for t_name in "${load_statistics_db_tables[@]}"
        do
            if [[ "${check_table}" == "${t_name}" ]]; then
                log_message "\tdelete action for ${t_name}"
                sqlite3 -init /dev/null "${db_name}" "delete from ${t_name}" &>>${logfile}
            fi
        done
    done
}

#func_msedge (){
#    log_message "${FUNCNAME[0]}()"
#    declare -a msdirs=("")
#    msdirs=$(command find /home -type d | command grep "\/.config/microsoft-edge" | awk -F'[//]' '{print $5}' | sort -u)
#    if [[ "${#msdirs[@]}" -gt 0 ]]; then
#        log_message "msdirs: ${#msdirs[@]} found\n"
#    fi
#}

MAIN() {
# Constant Variables
create_log
log_message

func_check_bleachbit
func_clear_files_recent 
func_delete_history 
if [ -x /usr/bin/trash-empty ]; then
    func_trash_empty 
fi
func_truncate_vlc_history 
func_run_vlc_cleaner

# Functions related to KDE
if ps aux | grep --quiet -i "/bin/startplasma"; then
    truncate_dragonplayerrc
    kde_recentdb
fi

func_browser_cleaner
clear_viminfo
func_run_bleachbit_thumbnails

# Cleaning up database tables
ar_browsers=("Brave" "opera" "microsoft-edge" "firefox")
log_message "Begin DB Functions"
for BROWSER in "${ar_browsers[@]}"
do
    log_message "\tCalling DB functions for: ${BROWSER}"
    DB_PATH=$HOME/.config
    func_db_top_sites
    func_db_history
    func_db_network_action_predictor
    func_db_load_statistics_db
done
log_message "Completed DB Functions"
log_message "actions completed see log (${logfile})"
exit 0
}

MAIN
