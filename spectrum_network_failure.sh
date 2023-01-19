#!/usr/bin/sh
#
# Script sends a ping to 8.8.8.8 every 10 seconds to confirm
# if Spectrum network connection is still active.
# When Spectrum network is down, script writes a connection failed
# message to console.
# When Spectrum network connect is restored, script writes a restored
# connection message to console.
#
restoreconrc=0
lostcount=0

while true
do
    ping -W2 -c3 8.8.8.8 &>/dev/null
    if [[ "$?" != "0" ]]; then
        lostcount=$((lostcount+1))
        printf "Connection #${lostcount} failed at $(date +%Y%m%d_%H%M%S)"
        restoreconrc=1
    else
        if [[ "${restoreconrc}" == "1" ]]; then
            printf "Connection restored at $(date +%Y%m%d_%H%M%S)"
        fi
        :
    fi
    sleep 10
done
