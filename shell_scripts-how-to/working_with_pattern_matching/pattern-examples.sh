#!/usr/bin/bash

myList=("cat" "dog" "rabbit" "elephant" "bat" "frog")

IFS=$'\n'

# Print all elements of array
echo ${myList[@]} 

# Print only lines that contain the text "rab"
printf -- "%s\n" "${myList[@]}" | grep rab

# Print only lines that contan "og"
printf -- "OG Match: %s\n" "${myList[@]}" | grep [og]


#Remove the entries from the LEFT edge in $PATH
printf "\n"
printf "Full PATH:\n\t${PATH}"
printf "\nRemoved 1st entry in PATH:\n\t${PATH#*:}"
printf "\nRemoved all except the last entry in PATH:\n\t${PATH##*:}"

#Remove the entries from the RIGHT edge
printf "\n"
printf "Full PATH:\n\t${PATH}"
printf "\nRemoved last entry in PATH:\n\t${PATH%:*}"
printf "\nRemoved all except the 1st entry in PATH:\n\t${PATH%%:*}"


#Included to return newline after printing all above
printf "\n"
