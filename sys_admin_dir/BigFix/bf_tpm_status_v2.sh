#!/bin/bash

bf_temp_dir="/tmp/bf_linuxatibm"
logfile="$bf_temp_dir/bf_tpm_status.log"
timeStamp=$(date +%Y%m%d_%H%M)
biosfile="/tmp/bios.ini"
#biosfile="/var/opt/beekeeper/bios.ini"

get_tpm_info (){
touch $biosfile
if [ -r /sys/class/tpm/tpm0 ]; then
    get_tpm_ver=$(grep ^"[[:digit:]]" /sys/class/tpm/tpm0/tpm_version_major)
    if (( 1 <= "$get_tpm_ver" && "$get_tpm_ver" <= 99 )); then
       echo "TPM Version = $get_tpm_ver" >> "$biosfile"
    else
       echo "TPM Version = Available" >> "$biosfile"
    fi
else
    echo "TPM Version = NOT FOUND" >> "$biosfile"
fi 
}

MAIN (){
    if [ ! -d $bf_temp_dir ]; then
        mkdir -p $bf_temp_dir
    fi
    touch "$logfile"
    (
	echo "Check TPM status - $timeStamp"
    get_tpm_info
	echo "Script completed"
    ) > $logfile
}

MAIN
