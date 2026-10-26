#!/usr/bin/bash

:<<'COMMENT'
Using and array to build a complex command and calling the
array.

Problem:
Attempts to pass '--user-agent' to the wget command fails

This will not work:
- wget_cmd=wget --timeout=3 --user-agent="${WGET_AGENT}" --no-check-certificate -a ./logs/get_${p_index}.log -O ${p_index} ${url}

The wget command will try to connect to each item listed in $WGET_AGENT 

The way you work around that issue is to place all command arguments in an array and then call the array.

CRITICAL: 
    - When calling the argument, enclose the array name in double quotes.
    - Found if remote site was enclosed in double quotes before being assigned to ${url},
    the wget command fails with unable to connect to "https".

COMMENT

WGET_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:121.0) Gecko/20100101 Firefox/121.0"
p_index="index.html"
url="www.c_69.com"

# Array contains valid arguments for the wget command
wget_cmd=(
    --verbose
    --timeout=3 
    --user-agent="${WGET_AGENT}"
    --no-check-certificate 
    --append-output="/var/tmp/get_${p_index}.log"
    -o ${p_index} 
    ${url}
)

wget_cmd2=(
    --verbose
    --timeout=3 
    --no-check-certificate 
    --append-output="/var/tmp/get_${p_index}.log"
    -o ${p_index} 
    ${url}
)

ls_cmd=(
    -alt
)

# Attempt to run the command
printf "DEBUG>>>\n"

wget "${wget_cmd[@]}" # Using the command, call the array which contains the arguments
ls ${ls_cmd[@]} ${p_index}






