#!/usr/bin/bash
loop_count=1
array_count=0

declare -a fixletArray
printf "\n"

for get_fixlet_id in $(command grep --max-count 10 --extended-regexp '.*Relevant.*\(fixlet:[[:digit:]].*\)$' "${HOME}"/BESLogs/TODAY.log \ | command grep --invert-match --ignore-case "not relevant")
do
    IFS=$'\n'
    printf "%s: Full string NAME: %s\n" "${loop_count}" "${get_fixlet_id}"
    get_fixlet_num=$(echo $get_fixlet_id | awk -F"\\\(fixlet:" '{print $2}' | awk '{gsub(/)/, "") ; print }')
    printf "Fixlet Num: %s\n" "${get_fixlet_num}"
    printf "\n"
    fixletArray[$array_count]="${get_fixlet_num}"
    loop_count=$((loop_count + 1))
    array_count=$((array_count + 1))
    printf "\nDEBUG >>> %s" "${fixletArray[$array_count]}"
done
printf "\n"

printf "\nDEBUG >>> fixletArray Total: %s" "${#fixletArray[@]}"
printf "\nDEBUG >>> fixletArray Elements %s" "${fixletArray[*]}"
printf "\n"

