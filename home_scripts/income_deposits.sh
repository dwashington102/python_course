#!/usr/bin/sh

:<<'COMMENTS'
 Script ingest CSV file of all banking transactions and totals deposits

 Deposits appear in the CSV file in this format:
 584,01/07/22,6700.00,Credit,Deposit from FID BKG SVC LLC MONEYLINE,7504.81


 Output:
Total Paychecks: $117,758.58
Total Investments $25,850.00
Total: $143,608.58
COMMENTS



function gen_logfile()
{
    if [ -f ${logfile} ]; then
        truncate -s0 ${logfile}
    fi
}


function check_csvfile ()
{
    printf "\n"
    if [ ! -f ${csvfile}  ]; then
        printf "CSV file $($csvfile) NOT FOUND...exit(101)\n"
        exit 101
    elif [ ! -r ${csvfile} ]; then
        printf "$(id -un) does not have READ permission on $($csvfile)\n"
        exit 102
    fi
    printf "Processing csv file: ${csvfile}\n"
}


function func_usage()
{
    echo "Usage: $(basename --suffix=.sh $0)  [-f file] [-d directory] [-h]"
    echo "Script parses CSV file downloaded from Capital One Banking"
    echo "Extracting the ',Credit,' entries in order to get the total income"
    echo "  -f file:          Include full path and csv filename"
    echo "  -d directory:     Location of output log file"
    echo "  -h help:          print this message and exit"
    exit 0
}


function main()
{
    IFS=$'\n'
    csvfile=""
    loopcount=1
    totalmel=0.00
    totaldavid=0.00
    totalinvestments=0.00
    total=0.00
    # Used to handle currency display
    export LC_NUMERIC=en_US.UTF-8
    
    mel=TASB
    david=IBM
    tax=MONEYLINE

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

    if [[ -z "${csvfile}" ]]; then
        echo "Enter full path and csv filename: "
        read csvfile
    fi

    if [[ -z "${logdir}" ]]; then
        logdir=$HOME
    fi

    logfile=$logdir/$(basename --suffix=.sh $0)_$(date +'%Y%m%d_%H%M').txt
    check_csvfile

    

    for line in $(command grep -E "Credit,Deposit" ${csvfile})
    do
            amount=$(command echo ${line} | awk -F',' '{print $3}')
    
            if echo "$line" | grep -q "$mel"; then
                totalmel=$(echo "$totalmel + $amount" | bc)
            elif  echo "$line" | grep -q "$david"; then
                totaldavid=$(echo "$totaldavid + $amount" | bc)
            elif  echo "$line" | grep -q "$tax"; then 
                totalinvestments=$(echo "$totalinvestments + $amount" | bc)
            fi
    
            total=$(echo "$total + $amount" | bc)
            loopcount=$((loopcount + 1))
    done
    
    totalpaychecks=$(echo ${totalmel} + ${totaldavid} | bc) 
    printf "Total Paychecks: $%'.2f\n" "${totalpaychecks}"
    printf "Total Investment Account $%'.2f\n" "${totalinvestments}"
    printf "Total: $%'.2f\n" "${total}"
}


main "$@"