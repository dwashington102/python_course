#!/usr/bin/bash

:<<'COMMENT'
COMMENT

# Declaring an Array
declare -a HostList=("k430-raptor" "x1-raptor" "p340-dove-docker" "p340-dove-fed35" "p50-raptor")

# Print contents of array with position numbers
declare -p HostList

# Generating an array from files in the current directory
myList=( $(find . -mindepth 1 -maxdepth 1 -type f -exec basename {} \;))

# Confirm contents of the array myList
declare -p myList

# Get a total count of the items in the array
printf "\nTotal Items In Array myList: %s" "${#myList[*]}"

# Total Length (characters) of array
printf "\nTotal Length Of Array myList: %s" "${#myList}"

# Iterate through array
loopCount=1
# NOTE:  Remember to add the following export in order to handle spaces/special chars
export IFS=$'\n'
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

# Appending elements to an array
declare -a myHosts=("x1-texas" "p340-texas" "k430-texas")
printf "\nCurrent myHosts Array: \n%s\n" "${myHosts[@]}"
myHosts+=("p50-texas")
printf "\nUpdated myHosts Array: \n%s\n" "${myHosts[@]}"

# Removing element from array


# Sorting Array Output
printf "\nSorted myHosts Array:\n"
printf "%s\n" "${myHosts[@]}" | sort

# Replace string in array
myHosts=( "${myHosts[@]/texas/usa}" )
printf "\nChanged hostnames in myHosts Array:\n%s\n" "${myHosts[@]}"

# Pulling out elements 0 and 3 from array
#printf "\nElements 0 and 3:\n\t%s\n" "${myHosts[@]:0:3}"






