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

