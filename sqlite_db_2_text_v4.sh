#!/usr/bin/bash
:<<'COMMENTS'
Script dumps contents of all SQLite3 Database files in the current directory
to text files.

The text files are 
COMMENTS

function func_set_colors ()
{
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}


function set_logfile()
{
    # Function: Created a log in the current directory.  After an AgentService.log file is successfully converted to a text file
    # entry is added in the log file.
    # Create a directory in the $CWD setting the directory name to timeStamp variable
    timeStamp=$(date +"%Y%m%d_%H%M%S")
    mkdir ${timeStamp}

    convert_log="${PWD}"/${timeStamp}/converted_files_success.txt
    touch ${convert_log} &>/dev/null
    truncate -s0 ${convert_log}

    echo $PWD >> ${convert_log}
    printf "\n"
    printf "%0.s-" {1..50} >> ${convert_log}
    printf "\n"
    printf "Files in current directory:\n\n" >> ${convert_log}
    file * >> ${convert_log}
    printf "%0.s-" {1..50} >> ${convert_log}
    printf "\n"
}


function get_tableNames()
{
    printf "Starting ${FUNCNAME[0]}()\n"
    declare -a get_sqlitedbList
    sqldbftype="SQLite.*database|data\ or.*text"

    IFS=$'\n'
    get_sqlitedbList=( $(file * | command grep -E "${sqldbftype}" | awk -F":" '{print $1}') )

    printf "Total SQLite DB files found in $PWD:\n ${#get_sqlitedbList[@]}\n"

    if [[ "${#get_sqlitedbList[@]}" -eq "0" ]]; then
         printf "No SQLiteDB files found in current directory ...exit(101)\n"
         exit 101
    fi

    for get_fileName in "${get_sqlitedbList[@]}"
    do
        printf "\n"
        printf "Processing SQLite3 database: ${get_fileName}\n"
        outputTables="${timeStamp}/${get_fileName}_db.tables"
        sqlite3 $get_fileName "select name from sqlite_master where type='table';" 2>/dev/null  > $outputTables

        if [[ "$?" -ne 0 ]]; then
            printf "\t\t${red}ERROR accessing db '${get_fileName}' encountered${normal}\n"
        fi

        if [ -s $outputTables ]; then
            mkdir ./$timeStamp/$get_fileName
            printf "\tBegin to process tables in: ./$outputTables...\n"
            for tableName in $(cat $outputTables)
            do
                tableRows=`sqlite3 ${get_fileName} "select count(*) from '$tableName'"`
                printf "\t\tNumber of rows for Table - '${tableName}':  ${tableRows}\n"
    
                if [ $tableRows -eq 0 ]; then
                    printf "\t\tTablename ${tableName} has 0 rows...skipping converting table\n"
                    printf "\n"
                else
                    sqlFile=./$timeStamp/$get_fileName/$tableName.txt
                    touch $sqlFile
                    printf "\t\tProcessing tablename: ${tableName}...\n"

                    touch $outputTables &>/dev/null
                    touch convert_wdg.sql &>/dev/null
                    truncate -s0 convert_wdg.sql 
                    echo ".mode csv" >> convert_wdg.sql
                    echo ".output '${sqlFile}'" >> convert_wdg.sql
                    echo "select * from ${tableName};" >> convert_wdg.sql
                    echo ".quit" >> convert_wdg.sql
                    sqlite3 ${get_fileName} ".read convert_wdg.sql"
                    printf "\t\tText file created --> ${sqlFile}\n"
                    /usr/bin/rm -f convert_wdg.sql
                    sleep 1
                    printf "\n"
                fi
            done
            /usr/bin/rm -f $outputTables
        else
            printf "\t\tTable: $outputTables has 0 rows no conversion attempted\n"
            /usr/bin/rm -f $outputTables
        fi
    done
}


main ()
{
    trap "{ rm -rf convert_wdq.sql ; exit 115; }" SIGKILL SIGTERM SIGQUIT SIGINT
    func_set_colors
    printf "Starting ${FUNCNAME[0]}()\n"
    set_logfile
    get_tableNames
    printf "\n"
    printf "Script completed see log ${convert_log}\n"
    printf "Completed ${FUNCNAME[0]}()\n"
}

main
