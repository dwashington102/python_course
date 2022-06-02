#!/usr/bin/bash

<< 'COMMENTS'
This script gathers the amount of time it takes to run ps commands
Using "grep command-name /proc/*/comm" appears to be much faster
COMMENTS



time (pgrep systemd-logind)

time (grep systemd-login /proc/*/comm)
