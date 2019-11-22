#!/bin/sh

cat /dev/null > /tmp/outputfiles_html
printf "DEBUG ${HOME}\n"

for myfile in `file ${HOME}/Temp/images/* | grep HTML | awk -F":" '{print $1}'`
do
	echo ${myfile} >> /tmp/outputfiles_html
done
exit
