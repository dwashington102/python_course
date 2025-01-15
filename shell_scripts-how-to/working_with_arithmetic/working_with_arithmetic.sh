#!/bin/bash

declare -i numVar1
declare -i numVar2

numVar1=10
numVar2=30

totalVar=$(($numVar1 + $numVar2))

printf "\nTotal: %s + %s" "$numVar1" "$numVar2"
printf "\n%s\n" "$totalVar"

# Using built-in "let" command
let "letvar=$numVar1 - $numVar2"
printf "Results from let command: ${letvar}\n"


