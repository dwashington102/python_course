#!/usr/bin/sh
#
:<<'COMMENTS'
Script ingest CSV of all banking ",Debit," transactions

",Debit," entries as they appear in CSV file
0584,12/16/22,-17.50,Debit,Debit Card Purchase - SCHLOTZSKY S 2100 CEDAR PARK TX,9939.85

Column 5 = merchant
Column 3 = amount

Sorts all transactions for each merchant and then totals
all transactions for the merchant.  If there were 4+ transactions at the merchangt, 
the script computes the avg. per transaction.
COMMENTS


# Used to handle currency display
export LC_NUMERIC=en_US.UTF-8

IFS=$'\n'
csvfile="/tmp/banking.csv"
loopcount=1
totalvisits=0
totalspent=0
totalatm=0

logfile=/tmp/output.txt

gen_logfile (){
    if [ -f ${logfile} ]; then
        truncate -s0 ${logfile}
    fi
}

do_work (){
    declare -a merchantarr=()
    for line in $(command grep -E ",Debit," ${csvfile} | command grep -E "\/22,-" | awk -F',' '{print $5}' | sort -u)
    do
        merchantarr+=("$line")    
    done

    for eachmerchant in ${merchantarr[@]}
    do
        printf "\n\n"
        printf "%0.s=" {1..50}
        printf "\n"
        printf "Transactions for ${eachmerchant}:\n"
        for getamount in $(command grep -E ",Debit," ${csvfile} | command grep -E "\/22,-" | grep ${eachmerchant})
        do
             getdollars=$(echo $getamount | awk -F',' '{print $3}' | awk -F'-' '{print $2}')
             getdate=$(echo $getamount | awk -F',' '{print $2}')
             totalspent=$(echo "$totalspent + $getdollars" | bc)
             totalvisits=$((totalvisits + 1))
             printf "${getdate} - ${getdollars}\n"
        done


        printf "\n"
        printf "Total Visits: ${totalvisits}\n"
        if [[ "$totalvisits" -gt "3" ]]; then
            avgcost=$(echo "$totalspent / $totalvisits" | bc)
            printf "Cost per Visit: $%.2f\n" "${avgcost}"
        fi
        printf "Total Spent: $%.2f\n" "${totalspent}"
        totalvisits=0
        totalspent=0
    done
    printf "%0.s=" {1..50}
    printf "\n"
}

atm_cash (){
    printf "\n"
    for line in $(command grep -E ",Debit," ${csvfile} | command grep -E "\/22,-" | command grep "ATM Withdrawal" | awk -F',' '{print $3}' | awk -F'-' '{print $2}')
    do
        totalatm=$(echo "$totalatm + $line" | bc)
    done
    printf "Total of all ATM Withdrawals: $%'.2f\n" "$totalatm"
}


get_transactions (){
    for eachmerchant in ${merchantarr[@]}
    do
        for line in $(command grep -E ",Debit," ${csvfile} | grep ${eachmerchant} | awk -F',' '{print $3}')
        do
             totalspent=$(echo "$totalspent + $line" | bc)
             totalvisit=$((totalvisit+1))
        done
        printf "\n\n"
        printf "%0.s=" {1..50}
        printf "\n"
        printf "Transactions for ${eachmerchant}:\n"
        printf "Total Visits: ${totalvisit}\n"
        printf "Total Spent: $%.2f\n" "${totalspent}"
        totalvisit=0
        totalspent=0
     done
}


main (){
    gen_logfile
    IFS=$'\n'
    (
    do_work
    atm_cash
    #----XXX----get_transactions
    ) >> ${logfile}
}


main