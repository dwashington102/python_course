#!/bin/bash

: <<'COMMENTS'
This script is being used to test adding entries to the user's 
crontab.  If the script works, we may add the functions in this 
script into the bg_enforcementregistration.sh
COMMENTS


func_copy_crontab (){
    if [ -f /tmp/bf_crontab.bak ]; then
        command rm -f /tmp/bf_crontab.bak
    fi
    crontab -l > /tmp/bf_crontab.bak
}

func_update_crontab (){
    echo "*/15 * * * * /tmp/bf_enforcementregistration.sh"  >> /tmp/bf_crontab.bak    
    crontab /tmp/bf_crontab.bak 
}

func_remove_bf_entry_crontab (){
    sed -i 's/.*bf_enforcementregistration.sh//' /tmp/bf_crontab.bak &>/dev/null
    crontab /tmp/bf_crontab.bak 
}

MAIN (){
    func_copy_crontab
    func_update_crontab
    func_remove_bf_entry_crontab
}

MAIN
