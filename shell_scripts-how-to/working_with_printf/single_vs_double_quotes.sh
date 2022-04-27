#!/usr/bin/bash

:<<'COMMENTS'
Lesson here is to use double quotes when attempting to print vars using printf or echo
COMMENTS


singleQuote="mickey"
doubleQuote="mouse"

printf "\n"
echo 'singleQuote variable $singleQuote'
#Results: singleQuote variable $singleQuote


echo "doubleQuote variable $doubleQuote"
#Results: doubleQuote variable mouse


printf "\nPrintf singleQuote variable %s" '$singleQuote'
#Results: Printf singleQuote variable $singleQuote


printf -- "\nPrintf doubleQuote variable %s"  "$doubleQuote"
#Results: Printf doubleQuote variable mouse