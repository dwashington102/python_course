#!/bin/bash

mapfile -t ar_journal < <(journalctl --list-boots)

printf "Total: (%s)\n" "${#ar_journal[@]}"

# Must set portcmd to array in order to pass to mapfile
if [ -f /sbin/ss ]; then
        portcmd=("/sbin/ss" "-tpln")
else
        portcmd=("/bin/netstat" "-tpln")
fi

# get sshd LISTENING PORT or set to default port (22)
mapfile -t SSHPORT < <("${portcmd[@]}" | grep sshd | awk -F':' '{print $2}' | awk '{print $1}')
if [ -z ${SSHPORT} ]; then
    SSHPORT="22"
fi

echo "DEBUG>>> SSHPORT ${SSHPORT} -> portcmd (${portcmd})" 

