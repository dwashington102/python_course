#!/bin/sh
# Version: 0.0.1
#
# Created 2021-10-16
#This script will check the Storage declaritive in the  /etc/systemd/journald.conf file to confirm the value is not set to "none".
#If the value is set to "none" --> Send an email alert --> Isolate when the change was made using journal or audit logs --> Revert the setting to "auto" --> Restart systemd-journald.


func_check_uid (){
    userId=$(id -u)
    if [ $userId == 0 ]; then
        now_timestamp=$(date +%Y%m%d_%H%M) 
        INFO_LOG=/root/cron_journald_${now_timestamp}.log
        CRIT_LOG=/root/CRIT_cron_journald_${now_timestamp}.log
        timeStamp=$(date +%Y%m%d_%H%M)
    else
        printf "\nUserID is non-root...exiting\n"
        exit 1
    fi
}


# Confirm the /etc/systed/journald.conf file exists before calling func_check_storage
func_check_journal (){
	if [ -f /etc/systemd/journald.conf ]; then
		func_check_storage
	else
		echo "/etc/systemd/journald.conf missing" > ${CRIT_LOG}
		exit 1
	fi
}

: <<'COMMENTS' 
Confirm the Storage declarative is NOT set to "none"
If the value is "none" send alerts, revert to auto, and write journalctl -b to log

Command to detect journal-flush: journalctl -b AUDIT_FIELD_UNIT=systemd-journal-flush
COMMENTS

func_check_storage (){
    command grep ^'Storage=none' /etc/systemd/journald.conf &>/dev/null
    if [[ $? -ne 0 ]]; then
	    echo "No changes to journald.conf: ${now_timestamp}" > ${INFO_LOG}

    else
	    echo "CRITICAL 'Storage=none' set in the /etc/systemd/journald.conf" > ${CRIT_LOG}
	    sed -i 's/Storage=none/Storage=auto/' /etc/systemd/journald.conf
	    systemctl restart systemd-journald.service > ${CRIT_LOG} &>/dev/null
	    if [[ $? -eq 0 ]]; then
		    echo "systemd-journal.service restarted at $(date +%H:%M)" >> ${CRIT_LOG}
		    printf "Current Storage setting in /etc/systemd/journald.conf:\n" >> ${CRIT_LOG}
		    command grep ^Storage= /etc/systemd/journald.conf >> ${CRIT_LOG}
	    else
		    echo "systemd-journal.service restarted at $(date +%H:%M)" >> ${CRIT_LOG}
		    echo "systemd-journal.service restart failed at $(date +%H:%M)" >> ${CRIT_LOG}
		    printf "Current Storage setting in /etc/systemd/journald.conf:\n" >> ${CRIT_LOG}
		    command grep ^Storage= /etc/systemd/journald.conf >> ${CRIT_LOG}
	    fi
    fi
}



MAIN (){
    func_check_uid
    func_check_journal
}


MAIN
exit 0

