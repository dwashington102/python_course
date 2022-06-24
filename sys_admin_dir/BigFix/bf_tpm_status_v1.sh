#!/bin/bash

bf_temp_dir="/tmp/bf_linuxatibm"
logfile="$bf_temp_dir/bf_tpm_status.log"
timeStamp=$(date +%Y%m%d_%H%M) 


do_work (){
if [ -r /sys/class/tpm/tpm0 ]; then
    get_tpm_ver=$(grep ^"[[:digit:]]" /sys/class/tpm/tpm0/tpm_version_major)
    if (( 1 <= "$get_tpm_ver" && "$get_tpm_ver" <= 99 )); then
        echo "TPM Version = $get_tpm_ver"
    else
	   echo "TPM Version = Available"
    fi
else
    echo "TPM Version = NOT FOUND"
    exit 4
fi
}

MAIN (){
    if [ ! -d "$bf_temp_dir" ]; then
        mkdir -p "$bf_temp_dir"
    fi
    touch "$logfile"
    (
	echo "Check TPM status - $timeStamp"
    do_work
	echo "Script completed"
    ) > $logfile
}

MAIN
