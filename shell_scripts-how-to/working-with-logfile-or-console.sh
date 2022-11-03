#!/bin/bash
#

tstamp=$(date +%Y%m%d_%H%M%S)
logstamp=$(date +%Y%m%d)
logfile="/tmp/${logstamp}.log"

logtimestamp (){
# Function prints timestamp before the log entries
command echo -n $(date --rfc-3339=seconds)" "
}


func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}


MAIN (){
    logtimestamp &>/dev/null
	# echo $TERM  <--DEBUG ONLY
	if [ "${TERM}" != "dumb" ]; then
	    echo "------------------------------------"
        logtimestamp ; echo "CONSOLE OUTPUT"
	    echo "------------------------------------"
	else 
	    [ ! -f ${logfile} ]
	    touch ${logfile}
	(
	    echo "------------------------------------"
	    # echo $TERM  <--DEBUG ONLY
        logtstamp ; echo "LOGFILE OUTPUT"
	    echo "------------------------------------"
	) >> $logfile
	fi
}


MAIN
