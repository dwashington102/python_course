#!/bin/bash 


# Values used to insert data into csv file
myuser=`whoami`
HNAME=$(hostname)
VMSTATS=$(vmstat  | awk '{print ":"$4":"$5":"$6":"}' | grep ^:[[:digit:]])
TSTAMP=$(date +"%Y%m%d%H%M%S")
#echo "DEBUG: $HNAME$VMSTATS$TSTAMP"

# Values
CMD='/usr/bin/sqlite3 /home/devdavid/databases/sqlite_db/databases/vstats.db ".read /home/devdavid/databases/sqlite_db/SQL_files/import.sql"'
COUNT=$(cat /home/devdavid/databases/sqlite_db/SQL_files/count.txt)
LOGFILEDIR='/home/devdavid/databases/sqlite_db/log_files'

# update_csv function writes data to the vmstat_out.csv file
update_csv(){ echo $HNAME$VMSTATS$TSTAMP >> /home/devdavid/databases/sqlite_db/csv_files/vmstat_out.csv ; }

#reset_count function sets the counter value to 0 by updating the count.txt file
reset_count(){ echo 0 > /home/devdavid/databases/sqlite_db/SQL_files/count.txt ; }


# If-Else loop actions -->
# --> When count = 0, an echo statement adds the header to the vmstat_out.csv 
# --> When count <= 30, update_csv() performs a vmstat command and dumps output to the vmstat_out.csv
# --> When count =31, update_csv() performs a vmstat command, dumps output to vmstat_out.csv, and ex_csv_glob_pandas.py pushes csv to mysql db. 
# 11-25-2019:
# Current DB connection: engine = sqlalchemy.create_engine('mysql+pymysql://devdavid:h3...@localhost:3306/testdb2')

if [ $COUNT -eq 0 ]; then
	echo "HOSTNAME:FREEMEM:BUFFER:CACHE:DATE" > /home/devdavid/databases/sqlite_db/csv_files/vmstat_out.csv
	echo $(( COUNT +1 )) > ~/databases/sqlite_db/SQL_files/count.txt
elif [ $COUNT -lt 30 ]; then
	update_csv
	echo $(( COUNT +1 )) > ~/databases/sqlite_db/SQL_files/count.txt
else
	update_csv

	# Export data from csv file to the sqlite VSTATS database
	#/usr/bin/sqlite3 /home/devdavid/databases/sqlite_db/databases/vstats.db ".read /home/devdavid/databases/sqlite_db/SQL_files/import.sql"

	# Export data from csv file to the mysql database
        /usr/bin/python3 /home/devdavid/GIT_REPO/python_course/ex_csv_glob_pandas.py

	# If the export is successful we write success to a log and the reset the counter to 0
	if [ $? == 0 ];
	then	
		echo "DEBUG: Enter IF-Success"
		echo "DEBUG: Successful imports $TSTAMP" >> $LOGFILEDIR/cron_success.imports
		reset_count
	else	
	# Else the export is unsuccessful and we write failure to a log and the reset the counter to 0
		echo "DEBUG: Enter IF-FAIL"
		echo "DEBUG: Failed imports $TSTAMP" >> $LOGFILEDIR/cron_fail.imports
		mv  /home/devdavid/databases/sqlite_db/csv_files/vmstat_out.csv  /home/devdavid/databases/sqlite_db/csv_files/vmstat_out.csv_$TSTAMP	
		reset_count
	fi
fi
