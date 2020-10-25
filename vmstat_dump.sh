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
# 3. Create sqlite db
# 4. Required python packages: pandas, sqlalchemy, pymysql
# 5. Create these files
#    	${HOME}/databases/sqlite_db/log_files/cron_fail.imports
#    	${HOME}/databases/sqlite_db/log_files/cron_success.imports
# 	    ${HOME}/databases/sqlite_db/SQL_files/count.txt
# 6. Optional --- create cron job to run the script


# Values used to insert data into csv file
myuser=`whoami`
HNAME=$(hostname)
#VMSTATS=$(vmstat  | awk '{print ":"$4":"$5":"$6":"}' | grep -Ev '^:-|^:-f')
VMSTATS=$(vmstat  | awk '{print ":"$4":"$5":"$6":"}' | grep ^:[[:digit:]])
TSTAMP=$(date +"%Y%m%d%H%M%S")
#echo "DEBUG: $HNAME$VMSTATS$TSTAMP"

# Values
CMD='/usr/bin/sqlite3 ${HOME}/databases/sqlite_db/databases/vstats.db ".read ${HOME}/databases/sqlite_db/SQL_files/import.sql"'
COUNT=$(cat ${HOME}/databases/sqlite_db/SQL_files/count.txt)
LOGFILEDIR='${HOME}/databases/sqlite_db/log_files'
LOGSUCCESS=${LOGFILEDIR}/cron_success.imports
LOGFAIL=${LOGFILEDIR}/cron_fail.imports

# update_csv function writes data to the vmstat_out.csv file
update_csv(){ echo $HNAME$VMSTATS$TSTAMP >> ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv ; }

#reset_count function sets the counter value to 0 by updating the count.txt file
reset_count(){ echo 0 > ${HOME}/databases/sqlite_db/SQL_files/count.txt ; }

log_success(){echo "DEBUG: Successful imports $TSTAMP" >> ${LOGSUCCESS}}
log_failure(){echo "DEBUG: Failed imports $TSTAMP" >> ${LOGFAIL}}


# If-Else loop actions -->
# --> When count = 0, an echo statement adds the header to the vmstat_out.csv 
# --> When count <= 30, update_csv() performs a vmstat command and dumps output to the vmstat_out.csv
# --> When count =31, update_csv() performs a vmstat command, dumps output to vmstat_out.csv, and ex_csv_glob_pandas.py pushes csv to mysql db. 
# 11-25-2019:
# Current DB connection: engine = sqlalchemy.create_engine('mysql+pymysql://devdavid:h3...@localhost:3306/testdb2')

if [ $COUNT -eq 0 ]; then
	#echo "HOSTNAME:FREEMEM:BUFFER:CACHE:DATE" > ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv
	touch ${HOME}/database/sqlite_db/SQL_files/count.txt
	echo $(( COUNT +1 )) > ${HOME}/databases/sqlite_db/SQL_files/count.txt
elif [ $COUNT -lt 30 ]; then
	update_csv
	echo $(( COUNT +1 )) > ${HOME}/databases/sqlite_db/SQL_files/count.txt
else
	echo ".import ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv VSTATS" >> ${HOME}/databases/sqlite_db/SQL_files/import.sql
	update_csv

	# Export data from csv file to the sqlite VSTATS database
	/usr/bin/sqlite3 ${HOME}/databases/sqlite_db/databases/vstats.db ".read ${HOME}/databases/sqlite_db/SQL_files/import.sql"

	# Export data from csv file to the mysql database
        #/usr/bin/python3 ${HOME}/GIT_REPO/python_course/ex_csv_glob_pandas.py

	# If the export is successful we write success to a log and the reset the counter to 0
	if [ $? == 0 ];
	then	
		#echo "DEBUG: Enter IF-Success"
		# 2010-10-25 ---> To do test if $LOGSUCCESS exists, if not create else append
		echo "DEBUG: Successful imports $TSTAMP" >> ${LOGSUCCESS}
#echo "DEBUG: Successful imports $TSTAMP" >> $LOGFILEDIR/cron_success.imports
		reset_count
	else	
	# Else the export is unsuccessful, we write failure to a log, backup existing CSV file for manual import and the reset the counter to 0
		#echo "DEBUG: Enter IF-FAIL"
		#echo "DEBUG: Failed imports $TSTAMP" >> $LOGFILEDIR/cron_fail.imports
# 2010-10-25 ---> To do test if $LOGFAIL exists, if not create else append
		echo "DEBUG: Failed imports $TSTAMP" >> ${LOGFAIL}
		mv  ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv  ${HOME}/databases/sqlite_db/csv_files/vmstat_out.csv_$TSTAMP	
		reset_count
	fi
fi
