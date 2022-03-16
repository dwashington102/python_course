#!/bin/sh

IFS=$'\n'
myArray=( $(ps auxh) )

count=1
for i in ${myArray[*]}
do
	printf "\nCount(%s)\t PID:%s" "$count" "$i"
	count=$((count + 1))
done

exit 0

