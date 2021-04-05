#!/bin/sh -x                                                                                                                                                                                     
# Version: 3.0
# Script gathers a list of files in the current directory, if the file type is "SQLite*database" the
# script will convert the contents of the database to a text file in text format.
# This allows L2 to view the contents of WDG log files using a standard text editor.
# 
# 2020-01-05:  The current WDG Log files share a common table (LogTable).  If additional tables are added to WDG Log files this script 
#              will require an updated "select * from" statement.
# 2020-02-12: Major overhaul to the script in order to dump all tables of the SQLite databses.  Turns out not all WDG SQLite databases
#             are using the common table (LogTable).

set_logfile() {
# Function: Created a log in the current directory.  After an AgentService.log file is successfully converted to a text file
# entry is added in the log file.
# Create a directory in the $CWD setting the directory name to timeStamp variable
timeStamp=$(date +"%Y%m%d_%H%M%S")
mkdir ${timeStamp}

convert_log="${PWD}"/${timeStamp}/converted_files_success.txt
touch ${convert_log} 2>&1 > /dev/null
cat /dev/null >! ${convert_log}
    

# Print a list of the files in the current directory.
# Printing a list of the files is for debugging purposes
echo $PWD >> ${convert_log}
printf "\n------------------------------" >> ${convert_log}
printf "\nFiles in current directory:\n\n" >> ${convert_log}
file * >> ${convert_log}
printf "\n-------------------------------" >> ${convert_log}
}

get_tableNames() {
IFS=$'\n'
for get_fileName in `file * | grep -E "SQLite.*database|data\ or.*text" | awk -F":" '{print $1}'`
do
    if [[ $? -eq 0 ]]; then
        outputTables="${timeStamp}/${get_fileName}_db.tables"
	touch $outputTables 2>/dev/null
	touch convert_wdg.sql 2>/dev/null
	cat /dev/null >! convert_wdg.sql 
	sqlite3 $get_fileName "select name from sqlite_master where type='table';"  >! $outputTables
	if [ -s $outputTables ]; then
		mkdir ./$timeStamp/$get_fileName
		printf "\n\nDEBUG>>> Begin to process tables in: ./$outputTables..."
		for tableName in `cat $outputTables`
		do
		    tableRows=`sqlite3 ${get_fileName} "select count(*) from '$tableName'"`
		    printf "\nDEBUG >>> tableRows for ${tableName}:  ${tableRows}"
		    if [ $tableRows -eq 0 ]; then
			printf "\nTablename ${tableName} has 0 rows...skipping converting table"
	            else
                        printf "\nRows gt 0"
		        sleep 3
		        sqlFile=./$timeStamp/$get_fileName/$tableName.txt
		        touch $sqlFile
		        printf "\nDEBUG>>> Processing tablename: ${tableName}..."
		        echo ".mode csv" >> convert_wdg.sql
		        echo ".output '${sqlFile}'" >> convert_wdg.sql
		        echo "select * from ${tableName};" >> convert_wdg.sql
		        echo ".quit" >> convert_wdg.sql
		        sqlite3 ${get_fileName} ".read convert_wdg.sql"
		        printf "\nDEBUG>>> Text file created --> ${sqlFile}"
		        sleep 5
		        cat /dev/null >! convert_wdg.sql
		    fi
		done
	else
		printf "\nDEBUG >> $outputTables is 0 bytes no conversion attempted"
	fi
    fi	
done
}

MAIN () {
set_logfile
get_tableNames
#printf "\n\n--------------------------------" >> ${convert_log}
#printf "\nFiles converted to text logs\n" >> ${convert_log}
#get_sqlite3_db_files
#printf "\nWork completed see ${convert_log}\n"
#printf "\n\n---------------------------------\n" >> ${convert_log}
#printf "\nConverted log files located in directory ${timeStamp}\n" >> ${convert_log}
}


MAIN

