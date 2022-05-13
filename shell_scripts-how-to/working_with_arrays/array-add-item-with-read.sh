#!/usr/bin/bash


:<<COMMENT
This script is a how-to when it comes to reading user input into an array
COMMENT



func_v1_read (){
declare -a arr
declare -a arrV2


unset itemCount
unset loopCount
declare -i itemCount=1
declare -i loopCount=1

printf "\nHow many items to search: "
read itemCount

while [ $loopCount -le $itemCount ]
do
    printf "\nDEBUG >>> Loop-%s\tItemCount-%s\n" "$loopCount" "$itemCount"
    echo "Enter search string"
    read searchString
    IFS=$'\n'
    arr+=("$searchString")      # <<<<<<<< This is the correct WAY
    arrV2+=$searchString        # <<<<<<<< THIS WAY IS JUST WRONG
    ((loopCount++))
done
printf "\nDEBUG >>> Dump array 'arr' from within ${FUNCNAME}\n"
printf "\t-%s" "${arr[@]}"
printf "\nDEBUG >>> Dump array 'arrV2' from within ${FUNCNAME}\n\t-%s" "${arrV2[@]}"
}

MAIN (){
func_v1_read
}

MAIN

