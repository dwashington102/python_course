#!/usr/bin/bash
:<<'COMMENTS'
Functions included in this script come from various scripts

bf_Code42_LTG.sh:
- check_uid(): Confirm script is being ran by root user
- logtstamp(): Used to add timestamp before echo to log
- func_set_log(): Create a log file using the <script name>.log
- set_lockfile(): Create a lock file used for install scripts


Exit Codes:
101 - check_uid(): Script must be ran as root user
104 - func_set_log():  Logfile directory does not exists
105 - set_lockfile(): Unable to create LOCKFILE 
112 - set_lockfile(): Existing LOCKFILE found
113 - set_lockfile(): Unable to delete LOCKFILE
COMMENTS


function check_uid ()
{
    # Check if script is being ran as root user
    logtstamp ; echo "${FUNCNAME[0]}()"
    if [ $(id -u) != "0" ]; then
        echo "Script must be ran as root!"
        exit 101
    fi
}

function logtstamp ()
{
    # Function to print timestamps before the log entries
    command echo -n $(date --rfc-3339=seconds)" "
}


function func_set_log ()
{
# function to generate log file
    bf_log_dir="/var/log/ibm"
    timeStamp=$(date +%Y%m%d_%H%M%S)
    logfile="${bf_log_dir}/$(basename --suffix=.sh $0).log"

    if [ ! -d "${bf_log_dir}" ]; then
        mkdir -p "${bf_log_dir}"
    fi

    if [[ -d "${bf_log_dir}" ]]; then
        touch $logfile
        truncate --size=0 $logfile
    else
        echo "logdir NOT FOUND...exit(104)"
        exit 104
    fi
}


function set_lockfile ()
{
    # function creates a lock file in order to avoid simultaneously running script
    # Lock file should be short lived.
    # If a lock file is older than 2 days, script removes the lock file
    logtstamp ; echo "${FUNCNAME[0]}()"
    LOCKFILE="/tmp/.bf_Code42_LTG.lock"
    if [[ -e "${LOCKFILE}" ]]; then
        deletefile=$(find /tmp -maxdepth 1 -name .bf_code42_LTG.lock -mtime +2)
        if [[ ! -z "${deletefile}" ]]; then
            logtstamp ; echo "+2day LOCKFILE FOUND"
            /usr/bin/rm --force $LOCKFILE &>/dev/null
            if [[ "$?" == "0" ]]; then
                logtstamp ; echo "LOCKFILE DELETED"
            else
                logtstamp ; echo " Unable to delete LOCKFILE...exit(113)"
                exit 113
            fi
        else
            logtstamp ; echo "Existing LOCKFILE FOUND...exit(112)"
            exit 112
        fi
    fi

    touch "${LOCKFILE}"
    if [ ! -f "${LOCKFILE}" ]; then
        logtstamp ; echo "failed to create LOCKFILE..exit(105)"
        exit 105
    fi
    logtstamp ; echo "LOCKFILE created"
}



main ()
{
    LOCKFILE="/tmp/.bf_Code42_LTG.lock"
    trap "{ rm -f $LOCKFILE /tmp/.bf_code42_LTG.lock ; exit 119; }"  SIGKILL SIGTERM SIGQUIT SIGINT
    check_uid
    logtstamp &>/dev/null
    func_set_log
    (
        check_uid
        set_lockfile
        # CRITICAL AFTER LOCKFILE IS SET ANY early EXITs should rm $LOCKFILE just before the 
        # early exit code is encountered
    ) >> ${logfile}
}


main
