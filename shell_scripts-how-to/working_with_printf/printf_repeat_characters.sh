#!/bin/bash

:<<'COMMENTS'
Print a row of characters like this
**********************
hello
**********************
COMMENTS

printf "%.s*" {1..50} ; printf "\n"
echo "hello"
printf "%.s*" {1..50} ; printf "\n"

# trying to print to a file
printf "%.s=" {1..50} >> /tmp/output.txt
printf "\n" >> /tmp/output.txt
echo "hello" >> /tmp/output.txt
printf "%.s*" {1..50} >> /tmp/output.txt
printf "\n" >> /tmp/output.txt

