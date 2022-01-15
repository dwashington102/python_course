#!/bin/sh
# 2021-01-15
# Script clears cache items
# 
#
# 2022-01-14: Updated  MAIN() to test for bleachbit before running functions that require bleachbit
# 2022-01-11: Updated func_clear_files_recent adding a check for recently-used.xbel
# 2021-04-18: Updated cp cmd in clear_files_recent to redirect STDOUT & STDERR to /dev/null
# 2020-01-16: Updated trash_empty() providing FQpath to trash-empty in order to avoid rc=127

# Constant Variables
tStamp=`date +%Y%m%d_%H%M`
logfile=$HOME/cronlogs/cron_run_$tStamp
spacer='------------//------------------'


func_clear_files_recent (){
	printf "\n"
	if [ -f $HOME/.local/share/recently-used.xbel ]; then
	    printf "Starting ${FUNCNAME}\n"
	    command cp $HOME/bin/static/recently-used.xbel $HOME/.local/share/recently-used.xbel &>/dev/null
	    printf "cp command rc=$?"
	else
	    printf "${FUNCNAME} results:  $HOME/static/recently-used.xbel does not exist." >> $logfile
	fi
	printf "\n"
}


func_bleachbit_cron_logs (){
	printf "\n"
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n" >> $logfile
	cd $HOME/cronlogs
	bleachbit -s `find . -type f -mtime +5` &>/dev/null
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}


func_delete_history (){
	printf "\n"
	printf "\nStarting ${FUNCNAME}\n"
	echo $SHELL | command grep zsh
	if [ $? == 0 ]; then
 		sed -i '/mp4/d' $HOME/.zsh_history
	else
		sed -i '/mp4/d' $HOME/.bash_history
	fi
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
}


func_run_bleachbit_cleaners (){
	printf "\n"
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	bleachbit -c system.trash firefox.cache google_chrome.cache opera.cache chromium.cache chromium.history chromium.cookies google_chrome.history vlc.mru > /dev/null 2>&1
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

func_run_bleachbit_targeted (){
	printf "\n"
	# only the printf statements in this function write to log file. Output of bleachbit command not included in log file
	printf "\nStarting ${FUNCNAME}\n"  >> $logfile
	cd $HOME/.cache/thumbnails
	bleachbit -s `find . -type f -name "*.png"` &>/dev/null
	printf "$FUNCNAME rc=$?\n" >> $logfile
	printf "\n"
}

func_trash_empty (){
	printf "\n"
	date +%H:%M:%S
	printf "Starting ${FUNCNAME}\n"
	$HOME/.local/bin/trash-empty 3 &>/dev/null
	date +%H:%M:%S
	printf "$FUNCNAME rc=$?\n" 
	printf "\n"
	
}

func_truncate_vlc_history (){
	printf "\n"
	printf "Starting ${FUNCNAME}\n"
	truncate -s 0 $HOME/.config/vlc/vlc-qt-interface.conf &>/dev/null
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
file $(command bleachbit -v) &>/dev/null
if [ $? == "0" ]; then
    printf "\nCalling bleachbit functions"
    func_bleachbit_cron_logs  
    func_run_bleachbit_cleaners
    func_run_bleachbit_targeted
    end_tStamp=$(date +%Y%m%d_%H:%M)
printf "End Time: ${end_tStamp}\n" >> $logfile
echo $spacer >> $logfile
else
    printf "bleachbit application NOT FOUND"
fi
printf "\n"
}

MAIN
exit 0
