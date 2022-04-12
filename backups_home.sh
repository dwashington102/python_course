#!/bin/sh


# Script creates a backup of the GNOMEDIR directory


#01-25-2022: Updated MAIN() to call func_set_log() in order to create the $logfile if it does not exist.
#            Without the change running the script while the $HOME/logs directory does not exists results in
#            the error "ambiguous redirect" 

# tstamp variable used in the creation of the tar.gz file in backup_extDir()
tstamp=$(date +%Y%m%d_%H%M%S)
GNOMEDIR="$HOME/.local/share/gnome-shell/extensions"
BACKUPDIR="$HOME/backups"
GITREPO="$HOME/GIT_REPO"

# function to generate log file
func_set_log (){
	logfile="$HOME/logs/backups_${tstamp}.log"
	if [ -d $HOME/logs ]; then
	    touch $logfile
	else 
	    mkdir -p $HOME/logs
	    touch $logfile
	fi
}


# cd to the Gnome extensions directory and backup the subdirectories to single compressed file
backup_extDir() {
    if [ -d $GNOMEDIR ]; then
	    pushd $GNOMEDIR
	    if [ -d $BACKUPDIR ]; then
		tar -zcf $HOME/backups/extensions_${tstamp}.tar.gz ./.
		printf "\ntar command rc=$?"
	    else
		mkdir $BACKUPDIR
		tar -zcf $HOME/backups/extensions_${tstamp}.tar.gz ./.
		printf "\ntar command rc=$?"
	    fi
    else
	    printf "\nDirectory $GNOMEDIR does not exist...exiting"
	    printf "\n"
	    exit 1
    fi
    printf "\n"
}


# cd to the GIT_REPO directory and remove all backups subdirectories older than 30 days.
clean_gitDir() {
    pushd $GITREPO
    if [[ $? != 0 ]]; then
        printf "\ncd to GIT REPO FAILED"
	    exit 1
    else
	    printf "\nDelete old directories"
	    for i in $(find . -type d -regextype posix-egrep -name "*.202[[:digit:]]*" -mtime +20)
	    do
		    rm -rf $i
		    printf "\nDelete directory $i rc=$?"
	    done
    fi
    printf "\n"
}


MAIN() {
    func_set_log
    (
    printf "\nBackup for $tstamp:\n"
    backup_extDir
    clean_gitDir
    ) >> ${logfile}
}

MAIN
