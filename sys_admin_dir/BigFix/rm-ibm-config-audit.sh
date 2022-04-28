#!/usr/bin/bash

:<<COMMENT
Script is used to remove the ibm-config-audit package.
- If removing the package fails the script disables the rule created by the package and throws RC=9


Exit Codes:
9 - Removing ibm-config-audit package failed
COMMENT

scriptName=$(basename "$0")
bf_temp_dir="/tmp/bf_linuxatibm/$scriptName"
timeStamp=$(date +%Y%m%d_%H%M)
logfile="$bf_temp_dir/$timeStamp.log"                                                                                                                                                   

delete_pkg (){													
rpm -q ibm-config-audit
if [ "$?" == "0" ]; then
    printf "\n\nStarting process to remove package\n"
	# Remove the --test option in order to delete package
	rpm --erase $(rpm -q --queryformat '%{NAME}\n' ibm-config-audit)
	rpm -q ibm-config-audit 
	if [ "$?" == "0" ]; then
	    printf "\n\nPackage was not removed...disabling 10-linuxatibm.rules\n"
        if [ -f /etc/audit/rules.d/10-linuxatibm.rules ]; then
		    printf "\n\nRemoving /etc/audit/rules.d/10-linuxatibm.rules\n"
            rm -f /etc/audit/rules.d/10-linuxatibm.rules
			printf "rm return code=$?"
			printf "\n\nRestarting audit service\n"
            systemctl restart auditd.service
			systemctl status auditd.service
		fi
		exit 9
	else
	    printf "\n\nPackage ibm-config-audit was sucessfully removed."
		exit 0
	fi
else
    printf "\n\nibm-config-audit package not found"
	exit 0
fi
}

MAIN (){
[ ! -d $bf_temp_dir ] && mkdir -p "$bf_temp_dir"
    touch "$logfile"
(
     delete_pkg
) > $logfile
}

MAIN
