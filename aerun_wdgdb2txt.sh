#!/bin/sh 
# Version: 2.0
# Script gathers a list of files in the current directory, if the file type is "SQLite*database" the
# script will convert the contents of the database to a text file in text format.
# This allows L2 to view the contents of WDG log files using a standard text editor.
# 
# Author:  David Washington 
# Any problems with the script please contact me via Slack or email (washingd@us.ibm.com)
#
# 2020-01-05:  The current WDG Log files share a common table (LogTable).  If additional tables are added to WDG Log files this script 
#              will require an updated "select * from" statement.



set_logfile() {
# Function: Created a log in the current directory.  After an AgentService.log file is successfully converted to a text file
# entry is added in the log file.
convert_log=${PWD}/converted_files_success.txt
touch ${convert_log}
cat /dev/null > ${convert_log}

# Create a directory in the $CWD setting the directory name to timeStamp variable
timeStamp=$(date +"%Y%m%d_%H%M%S")
mkdir ${timeStamp}


echo $PWD >> ${convert_log}
printf "\n------------------------------" >> ${convert_log}
printf "\nFiles in current directory:\n\n" >> ${convert_log}
file * >> ${convert_log}
printf "\n-------------------------------" >> ${convert_log}
}

get_sqlite3_db_files() {
# Function gathers a list of files in the current directory, if the file type is "SQLite*database" the
# contents of the database are written to a text file.
    for get_fileName in `file * | grep 'SQLite.*database' | awk -F":" '{print $1}'`
    do
        if [[ $? -eq 0 ]]; then
            outputFile="${timeStamp}/${get_fileName}.txt"
            touch convert_wdg.sql
            cat /dev/null > convert_wdg.sql
            echo ".mode csv" > convert_wdg.sql
            echo ".output ${outputFile}" >> convert_wdg.sql
            echo "select * from LogTable;" >> convert_wdg.sql
            echo ".output stdout" >> convert_wdg.sql
            echo ".quit" >> convert_wdg.sql
            sqlite3 ${get_fileName} ".read convert_wdg.sql"                                               
            printf "${get_fileName} converted to ${get_fileName}.txt\n" >> ${convert_log}
        fi
    done
}


MAIN () {
set_logfile
printf "\n\n--------------------------------" >> ${convert_log}
printf "\nFiles converted to text logs\n" >> ${convert_log}
get_sqlite3_db_files
printf "\nWork completed see ${convert_log}\n"
printf "\n\n---------------------------------\n" >> ${convert_log}
printf "\nConverted log files located in directory ${timeStamp}\n" >> ${convert_log}
}


# Calling my main MAIN
MAIN
exit 0