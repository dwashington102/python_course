#!/usr/bin/sh

:<<'COMMENTS'
Script sends a ping to 8.8.8.8 every 10 seconds to confirm
if Spectrum network connection is still active.
When Spectrum network is down, script writes a connection failed
message to console.
When Spectrum network connect is restored, script writes a restored
connection message to console.
#
The script is meant to be ran in a console or in background mode
DO NOT RUN from cron

CRITICAL: If running script spans multiple days, A new LOGFILE is not 
generated.  A sleeping script holds open connection to LOGFILE
COMMENTS

tstamp=$(date +'%Y%m%d')
logfile=$HOME/cronlogs/$(basename --suffix=.sh $0)_${tstamp}.log


func_check_logdir (){
   if [ ! -d $HOME/cronlogs ]; then
       mkdir -p $HOME/cronlogs
   fi
}


do_work (){
    # The do-done loop sends a ping to google
    # if the ping fails, jump into IF block 
    # Action of IF block: information is written showing # of loops the connection has been out,
    # date&time of outage, nmcli GENERAL.STATE info
    # Once the connection is restored, jump into ELSE block
    # the restoreconrc is reset to 0, information is written whowing Connection restore msg
    # Attempts to start VPN

    restoreconrc=0
    lostcount=0
    while true
    do
        ping -W2 -c3 8.8.8.8 &>/dev/null
        if [[ "$?" != "0" ]]; then
            if [ ! -f ${logfile} ]; then
                touch ${logfile}
            fi
            lostcount=$((lostcount+1))
            constate=$(nmcli -t con show SpectrumSetup-AF | command grep "GENERAL.STATE")
            printf "Connection #${lostcount} failed at $(date +%Y%m%d_%H%M%S)\tSTATE:${constate}\n"
            restoreconrc=1
        else
            if [[ "${restoreconrc}" == "1" ]]; then
                printf "Connection restored at $(date +%Y%m%d_%H%M%S)\n"
                restoreconrc=0

                nmcli -t con show "IBM Secure Access Service" &>/dev/null
                nmclirc="$?"
                if [[ "{$nmclirc}" == "0" ]]; then
                    $HOME/bin/connect-ibm-vpn.sh
                fi
            fi
            :
        fi
        sleep 10
    done
}


main (){
    (
    func_check_logdir
    do_work
    ) >> ${logfile}
}

if [[ ! -z "$1" ]]; then
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "Checks the device is connected to the network\n"
        printf "If the network is down, script write to the log and\n"
        printf "attempt to restart IBM VPN if it exists"
    else
        printf "spectrum_network_failure: Invalid option --- '$1'\n"
        printf "Try 'spectrum_network_failure.sh --help'\n"
    fi
    exit 0
fi
main
