#!/usr/bin/env bash
# Version: 3.0

# Script gathers a list of files in the current directory, if the file type indicates the file is a SQLite database the
# script attempts to convert the contents of the database to a text file.
# This allows IBM L2 to view the contents of WDG log files using a standard text editor.
# 
# 2020-01-05:  The current WDG Log files share a common table (LogTable).  If additional tables are added to WDG Log files this script 
#              will require an updated "select * from" statement.
#
# 2020-02-12: Major overhaul to the script in order to dump all tables of the SQLite databases.  Turns out not all WDG SQLite databases
#             are using the common table name (LogTable).

# This function creates a subdirectory in the $PWD in order to store log file and converted database text files
set_logfile_dir() {
timeStamp=$(date +"%Y%m%d_%H%M%S")
mkdir ${timeStamp}

if [[ $? != 0 ]]; then
    printf "\nUnable to create subdirectory...exiting now!"
else
    # Print a list of the files in the current directory.
    # Printing a list of the files is for debugging purposes
    convertResults=./${timeStamp}/converted_Results.txt
    touch "${convertResults}"
    #touch "${convertResults}" 2>&1 > /dev/null
    cat /dev/null > "${convertResults}"
    echo $PWD >> "${convertResults}"
    printf "\n------------------------------" >> "${convertResults}"
    printf "\nResults:" >> "${convertResults}"
fi
}

# Function connects to the SQLite database and counts the number of rows in the database
# If the number of rows == 0 the databse contents is not converted to a text file.
# If the number of rows > 0 the database contents are converted to a text file and stored 
# echo commands build the SQL file that is responsible for dumping the contents of each table to the outputText file
convert_db() {
tableRows=`sqlite3 "${get_fileName}" "select count(*) from '$tableName'"`
if [ $tableRows -eq 0 ]; then
    printf "\n\tTablename: ${tableName} contains 0 rows - skipping converting table contents to text file." >> ${convertResults}
else
    printf "\n\tTablename: ${tableName} contains '${tableRows}' rows converting table contents to text file." >> ${convertResults}
    mkdir -p ${outputLogs}
    outputText=${outputLogs}'/'$tableName.txt
    touch $outputText
    echo ".mode csv" >> convert_wdg.sql
    echo ".output '${outputText}'" >> convert_wdg.sql
    echo "select * from '${tableName}';" >> convert_wdg.sql
    echo ".quit" >> convert_wdg.sql
    sqlite3 "${get_fileName}" ".read convert_wdg.sql"
fi                        
rm -f ${outputTables}
}

# Function confirms if SQLite database files are found
# If the SQLite database files are found the function loops through each file, creating a .tables file.
# The .tables file contains a list of tables in the SQLite database 
# The function convert_db is ran against each table listed in the .tables file 

get_tableNames() {
IFS=$'\n'
file * | grep -E "SQLite.*database|data\ or.*text"  1>/dev/null 2>&1
if  [[ $? -ne 0 ]]; then
    printf "\nNo SQLite database files found in current directory.\n"
else
    for get_fileName in `file * | grep -E "SQLite.*database|data\ or.*text" | awk -F":" '{print $1}'`
    do
        if [[ $? -eq 1 ]]; then
            printf "\nmade it"
        exit 1
        else
            outputTables="${timeStamp}/${get_fileName}_db.tables"
            touch "$outputTables" 2>/dev/null
            touch convert_wdg.sql 2>/dev/null
            cat /dev/null > convert_wdg.sql
            sqlite3 "$get_fileName" "select name from sqlite_master where type='table' group by name having name != 'sqlite_sequence';"  > "$outputTables"
            if [ -s "$outputTables" ]; then
                outputLogs='./'$timeStamp'/'$get_fileName'_db_converted_dir'
                printf "\n${get_fileName} database: " >> ${convertResults}
                for tableName in `cat $outputTables`
                    do
                        convert_db
                     done
                rm -f convert_wdg.sql
            fi
        fi
    done
fi
}

MAIN () {
set_logfile_dir
get_tableNames
printf "\n------------------------------" >> "${convertResults}"
printf "\nWork completed see ${convertResults}\n"
printf "\n"
#printf "\n\n--------------------------------" >> ${convert_log}
#printf "\nFiles converted to text logs\n" >> ${convert_log}
#get_sqlite3_db_files
#printf "\nWork completed see ${convert_log}\n"
#printf "\n\n---------------------------------\n" >> ${convert_log}
#printf "\nConverted log files located in directory ${timeStamp}\n" >> ${convert_log}
}

MAIN


