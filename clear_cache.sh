#!/bin/sh
# 2021-01-15
# Script clears cache items
# 
#
# 2020-01-16: Updated trash_empty() providing FQpath to trash-empty in order to avoid rc=127
# 2021-04-18: Updated cp cmd in clear_files_recent to redirect STDOUT & STDERR to /dev/null

tStamp=`date +%Y%m%d_%H%M`
logfile=$HOME/cronlogs/cron_run_$tStamp
spacer='------------//------------------'


clear_files_recent (){
	printf "Starting ${FUNCNAME}\n"
	cp $HOME/bin/static/recently-used.xbel $HOME/.local/share/recently-used.xbel > /dev/null 2>&1
	printf "cp command rc=$?"
	printf "\n"
}


bleachbit_cron_logs (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n" >> $logfile
	cd $HOME/cronlogs
	bleachbit -s `find . -type f -mtime +5`
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}


delete_history (){
	printf "\nStarting ${FUNCNAME}\n"
 	sed -i '/mp4/d' $HOME/.zsh_history
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
}


run_bleachbit_cleaners (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	bleachbit -c system.trash firefox.cache google_chrome.cache opera.cache chromium.cache chromium.history chromium.cookies google_chrome.history vlc.mru
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

run_bleachbit_targeted (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	cd $HOME/.cache/thumbnails
	bleachbit -s `find . -type f -name "*.png"`
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

trash_empty (){
	printf "Starting ${FUNCNAME}\n"
	$HOME/.local/bin/trash-empty 3
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
	
}

truncate_vlc_history (){
	printf "Starting ${FUNCNAME}\n"
	truncate -s 0 $HOME/.config/vlc/vlc-qt-interface.conf
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
}



MAIN() {
touch $logfile
echo $spacer >> $logfile
clear_files_recent >> $logfile
delete_history >> $logfile
trash_empty >> $logfile 
truncate_vlc_history >> $logfile

#bleachbit functions should not append to $logfile here
bleachbit_cron_logs 
run_bleachbit_cleaners
run_bleachbit_targeted
echo $spacer >> $logfile
}

MAIN
exit 0
