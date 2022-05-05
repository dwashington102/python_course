#!/usr/bin/env bash

bes_list=("besclient" "beswebreports" "beswebui"  "besgatherdb" "besfilldb" "besserver")

func_besrunning() {
	pgrep BES &>/dev/null
	if [ "$?" == "0" ]; then 
            printf "\nBES Components are running....\n" 
        else
           printf "\nNo BES Components running...exiting\n" ; exit 0
	fi
}

func_stopbes() {
for besComp in ${bes_list[@]}
do
    printf "\nBES Component: %s" "$besComp"
    printf "\nStatus: "
    service "$besComp" status
    if [ "$?" == "0" ]; then
	    #printf "\nStopping $besComp..."
	    service "$besComp" stop
	    printf "\nReturn Code from stop command: $?"
	    printf "\n"
    else
	    printf "\nService $besComp is down"
	    printf "\n"
    fi
done
}

func_getpids() {
    printf "\nRunning BES Components:\n"
    ps -fp $(pgrep BES) | awk '{printf "\n%8s %6s %6s" $1,$2,$5,$9}' ; printf "\n"
}



MAIN (){
    func_besrunning
    func_getpids
    func_stopbes
}

MAIN
