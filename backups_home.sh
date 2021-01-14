#!/bin/sh

tstamp=`date +%Y%m%d`
cd $HOME/.local/share/gnome-shell/extensions
tar -zcf $HOME/backups/extensions_${tstamp}.tar.gz ./.

cd $HOME/GIT_REPO
rm -rf `find . -maxdepth 1 -type d  -mtime +10 -ls`

exit 0
