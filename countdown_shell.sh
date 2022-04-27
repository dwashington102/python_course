#!/usr/bin/bash


<< 'COMMENT'
Simple script that takes user's input (in minutes).  Using user's input, a count down is started.
Count down with 60 second sleep before displaying message to console
COMMENT

IFS=$'\n'
set_starttime=$(date)
get_clocktime='abc'

func_get_tot_time (){
    while [ "$get_clocktime" = 'abc' ]
    do
        printf "\nIs the countdown in (m)inutes or (h)ours?"
        printf '\nSelect 'm' for minutes or 'h' for hours:\t'
        read get_clocktime
        if [ "$get_clocktime"  == "h" ]; then
	    printf "\nTotal number of hours: "
	    read get_total_time
            set_total_time=$((60 * get_total_time))
        elif [ "$get_clocktime" == "m" ]; then
	    printf "\nTotal number of minutes: "
	    read get_total_time
            set_total_time=${get_total_time}
        else
        printf "\nInvalid choice. Try again.\nSelect 'm' for Minutes or 'h' for Hours"
	printf "\n"
	get_clocktime='abc'
        fi
    done

}


func_countdown (){
#    clear
    while [ "$set_total_time" -gt 0 ] 
    do
	printf "\n"
        date
	printf "Server is down for maintenance for another $set_total_time minutes\n"
	set_total_time=$((set_total_time - 1))
	sleep 60

    done
}


func_closing_message (){
	IFS=$'\n'
	set_endtime=$(date)
	printf "\nServer maintenance window is completed\n"
	printf "Start of maintenance window:\t%s\nEnd of maintenance window:\t%s\n" $set_starttime $(date)
}

MAIN (){
    func_get_tot_time
    func_countdown
    func_closing_message
    printf "\n"
}


MAIN
exit 0
