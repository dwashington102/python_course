#!/usr/bin/bash

if  (systemctl -q is-active sshd.service); then
	printf "\nUp and running"
else
	printf "\nNot running"
fi

exit 0
