#!/bin/sh
# 2021-01-15
# Script clears cache items
# 
#
# 2020-01-16: Updated trash_empty() providing FQpath to trash-empty in order to avoid rc=127
# 2021-04-18: Updated cp cmd in clear_files_recent to redirect STDOUT & STDERR to /dev/null

# Constant Variables
tStamp=`date +%Y%m%d_%H%M`
logfile=$HOME/cronlogs/cron_run_$tStamp
spacer='------------//------------------'


func_clear_files_recent (){
	printf "Starting ${FUNCNAME}\n"
	cp $HOME/bin/static/recently-used.xbel $HOME/.local/share/recently-used.xbel > /dev/null 2>&1
	printf "cp command rc=$?"
	printf "\n"
}


func_bleachbit_cron_logs (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n" >> $logfile
	cd $HOME/cronlogs
	bleachbit -s `find . -type f -mtime +5` > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}


func_delete_history (){
	printf "\nStarting ${FUNCNAME}\n"
	echo $SHELL | grep zsh
	if [ $? == 0 ]; then
 		sed -i '/mp4/d' $HOME/.zsh_history
	else
		sed -i '/mp4/d' $HOME/.bash_history
	fi
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
}


func_run_bleachbit_cleaners (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	bleachbit -c system.trash firefox.cache google_chrome.cache opera.cache chromium.cache chromium.history chromium.cookies google_chrome.history vlc.mru > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

func_run_bleachbit_targeted (){
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	cd $HOME/.cache/thumbnails
	bleachbit -s `find . -type f -name "*.png"` > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

func_trash_empty (){
	printf "Starting ${FUNCNAME}\n"
	$HOME/.local/bin/trash-empty 3 > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
	
}

func_truncate_vlc_history (){
	printf "Starting ${FUNCNAME}\n"
	truncate -s 0 $HOME/.config/vlc/vlc-qt-interface.conf > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
}



MAIN() {
touch $logfile
start_tStamp=`date +%Y%m%d_%H:%M`
echo $spacer >> $logfile
printf "Start Time: ${start_tStamp}\n" >> $logfile
func_clear_files_recent >> $logfile
func_delete_history >> $logfile
func_trash_empty >> $logfile 
func_truncate_vlc_history >> $logfile

#bleachbit functions should not append to $logfile here
func_bleachbit_cron_logs  
func_run_bleachbit_cleaners
func_run_bleachbit_targeted
end_tStamp=`date +%Y%m%d_%H:%M`
printf "End Time: ${end_tStamp}\n" >> $logfile
echo $spacer >> $logfile
}

MAIN
exit 0
