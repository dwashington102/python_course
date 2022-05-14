#!/bin/sh


<< 'COMMENT'
Script dumps output of 'ps auxh' adding a line number before each output.  This script is for loop testing
COMMENT

IFS=$'\n'
declare -a myArray
myArray=( $(ps auxh) )

count=1
for i in ${myArray[*]}
do
	printf "\nCount(%s)\t PID:%s" "$count" "$i"
	count=$((count + 1))
done
printf "\n"

