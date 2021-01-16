#!/bin/sh

tStamp=`date +%Y%m%d_%H%M`
logfile=$HOME/cronlogs/cron_run_$tStamp
spacer='------------//------------------'


clear_files_recent (){
	echo "\nStarting ${FUNCNAME}"
	printf "clear_files_recent...\n" 
	cp $HOME/bin/static/recently-used.xbel $HOME/.local/share/recently-used.xbel
	cd $HOME/.cache/thumbnails
	bleachbit -s `find . -type f -name "*.png"`
}


delete_cron_logs (){
	printf "\nStarting ${FUNCNAME]}\n"
	cd $HOME/cronlogs
	bleachit -s `find . -type f -mtime +5`

}


delete_history (){
	printf "\nStarting ${FUNCNAME}\n"
	printf "delete_history...\n"
 	sed -i '/mp4/d' $HOME/.zsh_history
}


run_bleachbit (){
	printf "\nStarting ${FUNCNAME}\n"
	bleachbit -c firefox.cache google_chrome.cache opera.cache chromium.cache chromium.history chromium.cookies google_chrome.history vlc.mru
}


truncate_vlc_history (){
	printf "\nStarting ${FUNCNAME}\n"
	truncate -s 0 $HOME/.config/vlc/vlc-qt-interface.conf
}



MAIN() {
touch $logfile
echo $spacer
run_bleachbit >>  $logfile
truncate_vlc_history >> $logfile
clear_files_recent >> $logfile
delete_history >> $logfile
echo $spacer
}

MAIN
exit 0
