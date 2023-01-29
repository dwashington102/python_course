#!/bin/bash
#
:<<'COMMENTS'
Script generates a log /tmp/bf_linuxatibm/{script}_{timestamp}.log

Contents of the log file
2023-01-28 20:59:26-06:00 write_log
2023-01-28 20:59:28-06:00 action (1/3)
2023-01-28 20:59:33-06:00 action (2/3)
2023-01-28 20:59:33-06:00 action (3) failed
2023-01-28 20:59:33-06:00 action (3/3)
COMMENTS

logtimestamp ()
{
    # Function prints timestamp before the log entries
    command echo -n $(date --rfc-3339=seconds)" "
}


func_set_log ()
{
# function to generate log file
    bf_temp_dir="/tmp/bf_linuxatibm"
    timeStamp=$(date +%Y%m%d_%H%M%S)
    # Add script name into the name of the generated log
    logfile="${bf_temp_dir}/$(basename --suffix=.sh $0)_${timeStamp}.log"

    if [ ! -d "${bf_temp_dir}" ]; then
        mkdir -p "${bf_temp_dir}"
    fi

    if [[ -d "${bf_temp_dir}" ]]; then
        touch $logfile
        truncate --size=0 $logfile
    else
        logtstamp ; echo "temp bf_linuxatibm dir NOT FOUND...exit(1)"
        exit 104
    fi
}



write_log ()
{
    # write function name to log file
    logtimestamp ; echo "${FUNCNAME[0]}"
    sleep 2
    logtimestamp ; echo "action (1/3)"
    sleep 5
    logtimestamp ; echo "action (2/3)"
    if  ! /usr/bin/rpm --query --quiet DEBUG &>/dev/null  ; then
        logtimestamp ; echo "action (3) failed"
    fi
    logtimestamp ; echo "action (3/3)"
}


MAIN ()
{
    logtimestamp &>/dev/null
    func_set_log
    (
        write_log
    ) >> $logfile
}

MAIN
