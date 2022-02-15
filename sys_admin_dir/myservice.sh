#!/usr/bin/bash

:<<COMMENTS
A better way to gather the status of service in a if-else statement
COMMENTS

printf "sshd.server status: %10s"
if  (systemctl -q is-active sshd.service); then
	printf "Up and running"
else
	printf "Not running"
fi
printf "\n"

exit 0
