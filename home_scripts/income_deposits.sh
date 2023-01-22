#!/usr/bin/sh

:<<'COMMENTS'
 Script ingest CSV file of all banking transactions and totals deposits

 Deposits appear in the CSV file in this format:
 584,01/07/22,6700.00,Credit,Deposit from FID BKG SVC LLC MONEYLINE,7504.81

COMMENTS

# Used to handle currency display
export LC_NUMERIC=en_US.UTF-8

IFS=$'\n'
csvfile="/tmp/banking.csv"
loopcount=1
totalmel=0.00
totaldavid=0.00
totalfidelity=0.00
total=0.00

mel=TASB
david=IBM
tax=MONEYLINE

for line in $(command grep -E "Credit,Deposit" ${csvfile})
do
        amount=$(command echo ${line} | awk -F',' '{print $3}')

        if echo "$line" | grep -q "$mel"; then
            totalmel=$(echo "$totalmel + $amount" | bc)
        elif  echo "$line" | grep -q "$david"; then
            totaldavid=$(echo "$totaldavid + $amount" | bc)
        else
            totalfidelity=$(echo "$totalfidelity + $amount" | bc)
        fi

        total=$(echo "$total + $amount" | bc)
        loopcount=$((loopcount + 1))

#        printf "Total Mel: $%.2f*s\n" 40 "${totalmel}"
#        printf "Total David: $%.2f*s\n" 40 "${totaldavid}"
#        printf "Total Fidelity $%.2f*s\n" 40 "${totalfidelity}"
#        printf "Total: ${total}\n"
#        sleep 1
done

totalpaychecks=$(echo ${totalmel} + ${totaldavid} | bc) 
printf "Total Paychecks: $%'.2f\n" "${totalpaychecks}"
printf "Total Fidelity $%'.2f\n" "${totalfidelity}"
printf "Total: $%'.2f\n" "${total}"

