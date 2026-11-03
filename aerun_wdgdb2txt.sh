#!/usr/bin/env bash
# Version: 3.0
:<<'COMMENTS'
Script gathers a list of files in the current directory, if the file type indicates the file is a SQLite database the
script attempts to convert the contents of the database to a text file.
This allows IBM L2 to view the contents of WDG log files using a standard text editor.

2020-01-05:  The current WDG Log files share a common table (LogTable).  If additional tables are added to WDG Log files this script 
will require an updated "select * from" statement.

2020-02-12: Major overhaul to the script in order to dump all tables of the SQLite databases.  Turns out not all WDG SQLite databases
are using the common table name (LogTable).
COMMENTS

function set_logfile_dir() {
    # This function creates a subdirectory in the $PWD in order to store log file and converted database text files
    timeStamp=$(date +"%Y%m%d_%H%M%S")
    if ! mkdir ${timeStamp}; then
        printf "\nUnable to create subdirectory...exiting now!"
        exit 101
    else
        # Print a list of the files in the current directory.
        # Printing a list of the files is for debugging purposes
        convertResults=./${timeStamp}/converted_Results.txt
        touch "${convertResults}" &>/dev/null
    
        # Ensure file is empty before processing
        if [ -s ${convertResults} ]; then
            truncate --size=0 "${convertResults}"
        fi
    
        echo "Processing files in directory: $PWD" >> "${convertResults}"
        printf "\n------------------------------" >> "${convertResults}"
        printf "\nResults:" >> "${convertResults}"
    fi
}


function convert_db() {
:<<'DESCRIPTION'
Function connects to the SQLite database and counts the number of rows in the database
If the number of rows == 0 the databse contents is not converted to a text file.
If the number of rows > 0 the database contents are converted to a text file and stored 
echo commands build the SQL file that is responsible for dumping the contents of each table to the outputText file
DESCRIPTION
    
    tableRows=`sqlite3 "${db_filename}" "select count(*) from '$tableName'"`
    if [[ ${loopcount} -le 10 ]]; then
        echo -n '.'
        loopcount=$((loopcount + 1))
    else
        printf "\n" && echo -n '.'
        loopcount=0
    fi

    if [[ $tableRows -eq 0 ]]; then
        printf "\n\tTablename: ${tableName} contains 0 rows - skipping converting table contents to text file.\n" >> ${convertResults}
    else
        printf "\n\tTablename: ${tableName} contains '${tableRows}' rows converting table contents to text file." >> ${convertResults}
        mkdir -p ${outputLogs}
        outputText=${outputLogs}'/'$tableName.txt
        touch $outputText
        truncate --size=0 convert_wdg.sql
        echo ".mode csv" >> convert_wdg.sql
        echo ".output '${outputText}'" >> convert_wdg.sql
        echo "select * from '${tableName}';" >> convert_wdg.sql
        echo ".quit" >> convert_wdg.sql
        sqlite3 "${db_filename}" ".read convert_wdg.sql"
    fi                        
    if [ -n "${outputText}" ]; then
        printf "\n" >>${convertResults} && ls -lG "${outputText}" >> ${convertResults}
        outputText=""  # added to avoid ls command printing same file name when tableRows==0
        debug_count=$((debug_count+1))
    fi
    # rm -f ${outputTables}
}


function get_tableNames() {
:<<'DESCRIPTION'
Function confirms if SQLite database files are found
If the SQLite database files are found the function loops through each file, creating a .tables file.
The .tables file contains a list of tables in the SQLite database 
The function convert_db is ran against each table listed in the .tables file 
DESCRIPTION

    IFS=$'\n'
    debug_count=1
    for db_filename in ${AR_LIST[@]}
    do
        if [[ ${debug_count} -gt 2000 ]]; then
            printf "DEBUG>>> Stopping here\n"
            exit 0
        fi
         
        # Page that holds list of table name found in db_filename
        outputTables="${timeStamp}/${db_filename}_db.tables"

        AR_empty=("convert_wdg.sql" "$outputTables")

        for create_file in ${AR_empty[@]};
        do
        if ! truncate --size=0 "${create_file}"; then
                printf "Unable to process ${db_filename}\n"
                break
        fi
        done

        sqlite3 "$db_filename" "select name from sqlite_master where type='table' group by name having name != 'sqlite_sequence';"  > "$outputTables"
        if [ -s "$outputTables" ]; then
            outputLogs='./'$timeStamp'/'$db_filename'_db_converted_dir'
            printf "\n\n${db_filename} database: " >> ${convertResults}
            loopcount=0
            for tableName in $(cat $outputTables)
            do
                printf "\n\tProcessing tableName -> ${tableName}" >> ${convertResults}
                convert_db
                rm -f ${outputTables} 
            done
        fi
    done
}

MAIN () {
AR_LIST=( $(file * | grep --color=NEVER -E "SQLite.*?database|data or.*text" | awk -F':' '{print $1}' 2>/dev/null) )
#if ! file * | grep -E "SQLite.*database|data\ or.*text" &>/dev/null; then 
if [[ ${#AR_LIST[@]} -lt 1 ]]; then 
    printf "No SQLite database files found in current directory.\n"
    exit 0
fi

set_logfile_dir
get_tableNames
printf "\n------------------------------" >> "${convertResults}"
printf "\nWork completed see ${convertResults}\n"
printf "\n"
}

MAIN
