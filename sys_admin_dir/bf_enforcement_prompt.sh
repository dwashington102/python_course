#!/usr/bin/bash
# Script prompts the user to provided full email address through a zenity dialog box.


func_copy_beekeeper (){
    command cp /var/opt/beekeeper/beekeeper.ini /tmp/bf_beekeeper.ini &>/dev/null || printf "\nUnable to copy beekeeper.ini...exiting\n" ; exit 1
}


func_get_email (){
    command ps axu | command grep -E 'zenity.*Registration GUI' &>/dev/null
    if [ $? == "0" ]; then
        getEmail=$(zenity --entry --width=400 --height=200 --text "***** THIS COMPUTER IS NOT REGISTERED *****\n\nRegistration is required when accessing internal IBM resources.\n\n" 2>/dev/null)
	if [ ! -z "$getEmail" ]; then
	    printf "\nEmail Address: "$getEmail"\n"
	else
	    printf "\nInvalid Email Address"
	fi
    fi
}


MAIN (){
    func_copy_beekeeper
    func_get_email
}


MAIN
exit 0

