#!/bin/bash

bf_temp_dir="/tmp/bf_linuxatibm"
logfile="$bf_temp_dir/bf_tpm_status.log"
timeStamp=$(date +%Y%m%d_%H%M) 


do_work (){
if [ -r /sys/class/tpm/tpm0 ]; then
    if grep -q ^1 /sys/class/tpm/tpm0/tpm_version_major; then
        echo "tpm version 1.x"
        exit 1
    elif grep -q ^2 /sys/class/tpm/tpm0/tpm_version_major; then
	   echo "tpm version 2.x"
	   exit 2
    else
        echo "/sys/class/tpm/tpm0 enabled"
        exit 3
    fi
else
    echo "Could not find the TPM information file, the TPM driver is probably not installed."
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
