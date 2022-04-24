#!/usr/bin/bash

# Count from 1 to 10 loop style
for (( i=1 ; i<=10; i++))
do
    printf "\nLine (%s)\n" "$i"
done

# Iterate over a list
declare -a myList=("apples" "cookies" "queso")
for i in ${myList[@]}
do
    printf "\nEating  %s\n" "$i"
done
