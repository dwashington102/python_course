#!/bin/sh

cat /dev/null > /tmp/outputfiles_html
printf "DEBUG ${HOME}\n"

for myfile in `file ${HOME}/Temp/images/* | grep --color=NEVER HTML\ document | awk -F":" '{print $1}' | grep images`
do
	echo ${myfile} >> /tmp/outputfiles_html
done
printf "Size of the outputfiles_html"
ls -lt /tmp/outputfiles_html
exit
