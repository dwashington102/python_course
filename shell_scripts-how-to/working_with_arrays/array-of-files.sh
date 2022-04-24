#!/usr/bin/bash

:<<'COMMENT'
COMMENT

# Declaring an Array
declare -a HostList=("k430-raptor" "x1-raptor" "p340-dove-docker" "p340-dove-fed35" "p50-raptor")

# Generating an array
myList=( $(find . -mindepth 1 -maxdepth 1 -type f -exec basename {} \;))

# Get a total count of the items in the array
printf "\nTotal Items In Array: %s" "${#myList[@]}"

# Iterate through array
loopCount=1
for eachItem in ${myList[@]}
do
    printf "\n(%s) Filename: %s" "$loopCount" "$eachItem"
done

# Grep string in array
# NOTE: The "--" option tells printf that whatever follows is NOT a command line option
IFS=$'\n'
printf -- "\nGrepping Through Array:\t"
printf -- '%s\n' "${myList[@]}" | grep array
printf -- "\n"

# Alternative method to grep an array
# IFS=$'\n'
# echo "${myList[*]" | grep myfilename

# Adding elements to an empty array 
# See danger_kernel_remove.sh

# Adding elements to an array
declare -a myHosts=("x1" "p340" "k430")
printf "Current myHosts Array: \n%s\n" "${myHosts[*]}"

myHosts+="p50"
printf "Updated myHosts Array: \n%s\n" "${myHosts[*]}"






