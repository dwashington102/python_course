#!/usr/bin/bash
IFS=$'\n'
loop_count=0

printf "\n"
for get_fixlet_id in $(command grep --max-count 10 --extended-regexp '.*Relevant.*\(fixlet:[[:digit:]].*\)$' "${PWD}"/TODAY.log | command grep --invert-match --ignore-case "not relevant")
do
    loop_count=$((loop_count + 1))
    printf "%s: Full string NAME: %s\n" "${loop_count}" "${get_fixlet_id}"
    get_fixlet_num=$(echo $get_fixlet_id | awk -F"\\\(fixlet:" '{print $2}' | awk '{gsub(/)/, "") ; print }')
    printf "Fixlet Num: %s\n" "${get_fixlet_num}"
    printf "\n"
done
printf "\n"

