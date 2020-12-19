#!/bin/sh 
# Script gathers a list of files in the current directory, if the file type is "SQLite*database" the
# script will convert the contents of the database to a text file in csv format.
# This allows L2 to view the contents of WDG AgentService.log file using a standard text editor.


set_logfile() {
# Function: Created a log in the current directory.  After an AgentService.log file is successfully converted to a CSV file
# entry is added in the log file.
convert_log=${PWD}/converted_files_success.txt
touch ${convert_log}
cat /dev/null > ${convert_log}

echo $PWD >> ${convert_log}
printf "\n--------+---------------------" >> ${convert_log}
printf "\nFiles in current directory:\n\n" >> ${convert_log}
file * >> ${convert_log}
printf "\n--------++---------------------" >> ${convert_log}
}

get_sqlite3_db_files() {
# Function gathers a list of files in the current directory, if the file type is "SQLite*database" the
# contents of the database are written to a csv file.
    for get_fileName in `file *.db | grep 'SQLite.*database' | awk -F":" '{print $1}'`
    do
        if [[ $? -eq 0 ]]; then
            #printf "DEBUG: Filename IS SQLITE DB: ${get_fileName}\n"
            touch convert_wdg.sql
            cat /dev/null > convert_wdg.sql
            echo ".mode csv" > convert_wdg.sql
            echo ".output ${get_fileName}.csv" >> convert_wdg.sql
            echo "select * from VSTATS;" >> convert_wdg.sql
            echo ".output stdout" >> convert_wdg.sql
            echo ".quit" >> convert_wdg.sql
            sqlite3 ${get_fileName} ".read convert_wdg.sql"                                               
            printf "${get_fileName} converted to ${get_fileName}.csv\n" >> ${convert_log}
        fi
    done
}


MAIN () {
set_logfile
printf "\n\n-------------+++----------------\n" >> ${convert_log}
printf "\nFiles converted to CSV\n" >> ${convert_log}
get_sqlite3_db_files
printf "\nWork completed see ${convert_log}\n"
printf "\n\n---------------++++--------------\n" >> ${convert_log}
}


# Calling my main MAIN
MAIN
exit 0