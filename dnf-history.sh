#!/usr/bin/sh
:<<'COMMENTS'
Script gathers a list of the last 10 dnf transactions and then 
gathers information about each transaction
COMMENTS

touch /tmp/history-info.txt
truncate -s0 /tmp/history-info.txt
count=0

printf "Gathering list of last 10 dnf transactions...\n"
for entry in $(dnf history --reverse | tail -n10 | awk '{print $1}')
do
    count=$((count+1))
    echo "(${count}) Processing transaction id: ${entry}"
    printf "\n------\n" >> /tmp/history-info.txt
    dnf history info ${entry} >> /tmp/history-info.txt
done

printf "\nAttach file /tmp/history-info.txt to the Slack thread\n"
