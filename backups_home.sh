#!/bin/sh
# Testing git push

tstamp=`date +%Y%m%d`
cd $HOME/.local/share/gnome-shell/extensions
if [ $? == 0 ]; then
	tar -zcf $HOME/backups/extensions_${tstamp}.tar.gz ./.
	cd $HOME/GIT_REPO
	rm -rf `find . -maxdepth 1 -type d  -mtime +10 -ls`
fi
exit 0
