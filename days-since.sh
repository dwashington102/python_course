#!/usr/bin/bash


echo "Start date: "
echo "Format: YYYY-MM-DD"
read start_date
# start_date="2023-05-02"
current_date=$(date +%Y-%m-%d)

start_timestamp=$(date -d "$start_date" +%s)
current_timestamp=$(date -d "$current_date" +%s)

days=$(( (current_timestamp - start_timestamp) / 86400 ))

echo "Number of days since $start_date: $days"

