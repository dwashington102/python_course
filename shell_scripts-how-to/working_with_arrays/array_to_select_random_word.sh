#!/usr/bin/bash


<<'COMMENTS'
Script pulls a random word(s) from /usr/share/dict/words

Logic:
> Build array using contents of /usr/share/dict/words
> Set max. random value to the total number of items in array
> Set random value in order to identify word in array
> Grab random word using array[random value] 
COMMENTS



MAIN (){
    wordArray=( $(cat /usr/share/dict/words) )
    if [ "${#wordArray[*]}" -ne "0" ]; then
        maxValue="${#wordArray[@]}"
        randValue=$(( RANDOM % $maxValue ))
        arrayItem=$(($randValue - 1))
        printf "\nDEBUG RandValue >>> %s" "$randValue"
        printf "\nDEBUG ArrayItem >>> %s" "$arrayItem"
        printf "\nDEBUG FINAL WITHOUT QUOTES: %s" "${wordArray[$arrayItem]}"
        printf "\nDEBUG FINAL: %s" "${wordArray["$arrayItem"]}"
    else
        printf "\nWord Arry = 0"
    fi
    printf "\n"
}

MAIN