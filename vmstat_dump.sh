#!/bin/bash -x
# Prereqs for running this script
# Details on G-drive: https://docs.google.com/document/d/1dS4qNmQ5aAQOshG7xX1-fgD8WTYpoWT79l3i6td0sc4
# 
# 1. Install required OS sqlite3 packages
# 2. Create the database directories:
# 	mkdir -p ~/databases/sqlite_db/databases
# 	mkdir -p ~/databases/sqlite_db/csv_files
# 	mkdir -p ~/databases/sqlite_db/import_files
# 	mkdir -p ~/databases/sqlite_db/export_files
# 	mkdir -p ~/databases/sqlite_db/SQL_files
# 	mkdir -p ~/databases/sqlite_db/log_files
# 3. Create sqlite db (vstats.db)
# 4. Required Python packages: pandas, sqlalchemy, pymysql
# 5. Create these files  <--2020-10-25: Currently working to auto create the following files if they do not exist
# 	    ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt
# 	    echo 0 > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt
           
# 6. Optional --- create cron job to run the script


# Values used to insert data into csv file
myuser=`whoami`
HNAME=$(hostname)
VMSTATS=$(vmstat -wa -SM  | awk '{print ":"$4":"$5":"$6":"}' | grep ^:[[:digit:]])
TSTAMP=$(date +"%Y%m%d%H%M%S")

# Values
CMD='/usr/bin/sqlite3 ${HOME}/databases/sqlite_db/databases/vstats.db ".read ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql"'
COUNT=$(cat ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt)
LOGFILEDIR=${HOME}/databases/sqlite_db/log_files
LOGSUCCESS=${LOGFILEDIR}/cron_success.imports
LOGFAIL=${LOGFILEDIR}/cron_fail.imports

######################## Functions
# update_csv function writes data to the vmstat_out.csv file
update_csv(){ echo $HNAME$VMSTATS$TSTAMP >> ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv ; }

#reset_count function sets the counter value to 0 by${HOME}/databases/sqlite_db/log_files updating the count.txt file
reset_count(){ echo 0 > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt ; }

# Write to sucess log file
log_success(){ echo "Debug: Successful imports $TSTAMP" >> ${LOGSUCCESS} ; }

# Write to failure log file
log_failure(){ echo "Debug: Failed imports $TSTAMP" >> ${LOGFAIL} ; }

if [ $COUNT -eq 0 ]; then
	# This IF statement resets count to 0 then increments to 1 
	#echo "HOSTNAME:FREEMEM:BUFFER:CACHE:DATE" > ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv
	echo "0" > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt
	echo $(( COUNT +1 )) > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt
elif [ $COUNT -lt 30 ]; then
	# This elif statement updates the CSV file and increments by 1
	update_csv
	echo $(( COUNT +1 )) > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_count.txt
elif [ $COUNT -ge 30 ]; then
	# This elif statement attempts to export contents of the csv file to the SQLite db
	# Adding "grep import... " statement to test if the vmstat_db_import.sql file contains import command
	grep import ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
	if [ $? != 0 ]; then
# 2020-11-14:   TO DO
#### It may be necessary to null out the vmstat_db_import.sql file and rebuild it adding
		cat /dev/null > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
		echo ".mode csv" > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
		echo ".separator ':'" >> ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
		# IF statement will add import statement to vmstat_db_import.sql if missing, update csv file,  and then attempt export of csv file
		echo ".import ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv VSTATS" >> ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
		update_csv
		# Export data from csv file to the sqlite VSTATS database
		/usr/bin/sqlite3 ${HOME}/databases/sqlite_db/databases/vstats.db ".read ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql"
	else
		# else statement will update csv file and attempt export of csv file
		update_csv
		/usr/bin/sqlite3 ${HOME}/databases/sqlite_db/databases/vstats.db ".read ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql"
		if [ $? == 0 ]; then	
			# if statement writes success msg, resets count, truncates csv file
			if [ -f $LOGSUCCESS ]; then
				log_success
				reset_count
				truncate -s 0 ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv
			else 
				#else statement creates the success log, write success msg, resets count, truncates csf file
				echo "CREATED SUCCESS LOG" >> $LOGSUCCESS
				log_success
				reset_count
				truncate -s 0 ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv
			fi
		else	
			#else statement rebuilds vmstat_db_import.sql for the next running of the script and writes failure msg to indicate an export failed 
			#during this cycle
			cat /dev/null > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
			echo ".mode csv" > ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
			echo ".separator ':'" >> ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
			# IF statement will add import statement to vmstat_db_import.sql if missing, update csv file,  and then attempt export of csv file
			echo ".import ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv VSTATS" >> ${HOME}/databases/sqlite_db/SQL_files/vmstat_db_import.sql
			if [ -f $LOGFAIL ]; then
				log_failure
			else
				echo "CREATED FAILURE LOG" >> $LOGFAIL
				log_failure
			fi
		fi
	fi
else
	printf "Exception encountered with COUNT value: ${COUNT}\t rc= $?"
	exit 1
fi

exit 0
