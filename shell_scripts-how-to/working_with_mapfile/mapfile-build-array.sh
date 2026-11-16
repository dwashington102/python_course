#!/bin/bash
:<<'DESCRIPTION'
Using the mapfile to read contents of a file into an array
DESCRIPTION


mapfile -t ar_dblist < ./static/db_names.txt

printf "Database: %s\n" "${ar_dblist[@]}"

for db_name in "${ar_dblist[@]}"
do
    printf "Loop through array -> %s\n" "${db_name}"
done


