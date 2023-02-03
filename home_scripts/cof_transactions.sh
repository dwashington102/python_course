#!/usr/bin/sh
#
:<<'COMMENTS'
Script ingest CSV for all banking ",Debit," transactions

",Debit," entries as they appear in CSV file
0584,12/16/22,-17.50,Debit,Debit Card Purchase - SCHLOTZSKY S 2100 CEDAR PARK TX,9939.85

Column 5 = merchant
Column 3 = amount

Sorts all transactions for each merchant and then totals
all transactions for the merchant.  If there were 4+ transactions at the merchangt, 
the script computes the avg. per transaction.

Same of output:
Transactions for ATM Withdrawal - BIG BUCKET -449808 A449808 AUSTIN  TX:  
12/30/21 - 63.00
12/05/21 - 63.00
11/22/21 - 63.00
10/24/21 - 63.00
07/20/21 - 63.00
05/08/21 - 43.00
03/23/21 - 43.00
02/01/21 - 103.00

Total Visits: 8
Cost per Visit: $63.00
Total Spent: $504.00
COMMENTS


gen_logfile() {
    if [ -f ${logfile} ]; then
        truncate -s0 ${logfile}
    fi
}

do_work() {
    # Function reads csv file extracting column 5 (sort for unique) and add each entry to the array merchantarr
    #  - foreach item in array merchantarr, extract column 3 and remove preceding "-"
    #  -  extract date from csv 
    #  Write merchant, date - amount, total visits and if total visit 4+, print avg cost per visit, total cost

    declare -a merchantarr=()
    for line in $(command grep -E ",Debit," ${csvfile} | command grep -E "\/2[[:digit:]],-" | awk -F',' '{print $5}' | sort -u)
    do
        merchantarr+=("$line")    
    done

    for eachmerchant in ${merchantarr[@]}
    do
        #Next line adds 50 = just for formatting
        printf "%0.s=" {1..50}
        printf "\n"
        printf "Transactions for ${eachmerchant}:\n"
        for getamount in $(command grep -E ",Debit," ${csvfile} | command grep -E "\/2[[:digit:]],-" | grep ${eachmerchant})
        do
             getdollars=$(echo $getamount | awk -F',' '{print $3}' | awk -F'-' '{print $2}')
             getdate=$(echo $getamount | awk -F',' '{print $2}')
             totalspent=$(echo "$totalspent + $getdollars" | bc -l)
             totaltransactions=$((totaltransactions + 1))
             printf "${getdate} - ${getdollars}\n"
        done


        printf "\n"
        printf "Total Visits: ${totaltransactions}\n"
        if [[ "$totaltransactions" -gt "3" ]]; then
            avgcost=$(echo "$totalspent / $totaltransactions" | bc -l)
            printf "Cost per Visit: $%.2f\n" "${avgcost}"
        fi
        printf "Total Spent: $%.2f\n" "${totalspent}"
        totaltransactions=0
        totalspent=0
    done
    printf "\n"
    printf "%0.s=" {1..50}
    printf "\n"
    printf "Total Number of Unique Merchants: ${#merchantarr[*]}\n"
    printf "Total Number of DEBITS from account: $(command grep -c -E ',Debit,' ${csvfile})\n"
    printf "%0.s=" {1..50}
    printf "\n"
}

atm_cash (){
    # Entries in csv file for ATM Withdrawals appear in this format
    # 0584,01/01/23,-63.50,Debit,ATM Withdrawal - RANDALLS LEA-K424590 LK424590 LEANDER  TX,11207.71
    printf "\n"
    for line in $(command grep -E ",Debit," ${csvfile} | command grep "ATM Withdrawal" | awk -F',' '{print $3}' | awk -F'-' '{print $2}')
    #for line in $(command grep -E ",Debit," ${csvfile} | command grep -E ",[[:digit:]]{1}\/[[:digit:]]{1}\/2[[:digit:]],-" | command grep "ATM Withdrawal" | awk -F',' '{print $3}' | awk -F'-' '{print $2}')
    do
        totalatm=$(echo "$totalatm + $line" | bc -l)
    done
    printf "Total of all ATM Withdrawals: $%'.2f\n" "$totalatm"
}


check_csvfile (){
    printf "\n"
    if [ ! -f ${csvfile}  ]; then
        printf "CSV file $($csvfile) NOT FOUND...exit(101)\n"
        exit 101
    elif [ ! -r ${csvfile} ]; then
        printf "$(id -un) does not have READ permission on $($csvfile)\n"
        exit 102
    fi
}


func_usage() {
    echo "Usage: $(basename --suffix=.sh $0)  [-f file] [-d directory] [-h]"
    echo "Script parses CSV file downloaded from Capital One Banking"
    echo "  -f file:          Include full path and csv filename"
    echo "  -d directory:     Location of output log file"
    echo "  -h help:          print this message and exit"
    exit 0
}


main() {
    IFS=$'\n'
    
    # Used to handle currency display
    export LC_NUMERIC=en_US.UTF-8
    loopcount=1
    totaltransactions=0
    totalspent=0
    totalatm=0
    csvfile=""
    logdir="$HOME"
     

    if [[ "$#" -eq "0" ]]; then
        logdir="/tmp"
        echo "Provide path and filename for csv file"
        read csvfile
    fi

    while getopts "f:d:h" opt
    do
        case "$opt" in
            f) csvfile="$OPTARG" ;;
            d) logdir="$OPTARG"  ;;
            h) func_usage ;;
            *) func_usage ;;
        esac 
    done

    #csvfile="/tmp/banking_2021.csv"
    logfile=$logdir/$(basename --suffix=.sh $0)_$(date +'%Y%m%d_%H%M').txt

    check_csvfile
    printf "Processing ${csvfile} files...\n"
    gen_logfile
    IFS=$'\n'
    (
    do_work
    atm_cash
    ) >> ${logfile}
    printf "\n"
    printf "Output written to ${logfile}\n"
}


main "$@"
