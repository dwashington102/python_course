# Import the required modules
import mysql.connector
from  pathlib import Path
import os
import csv
# Added the following module due to this error:
#   File "csv_to_vmstatdb_mysql.py", line 40, in export_csvfile
#   csv_data = csv.reader(file(csvfile))
#   TypeError: '_io.TextIOWrapper' object is not callable
from io import TextIOWrapper


# Set the GLOBAL CONSTANTS
# Define GLOBAL CONSTANTS
HOMEDIR = str(Path.home())
CSVFILELOC = HOMEDIR + '/sqlite_db/csv_files/'

def main():
    get_csvfiles()
    export_csvfile()


def get_csvfiles():
    list_csvfiles = []
    for (read, directory, file) in os.walk(CSVFILELOC):
        try: 
            for csvfile in file:
                csvfile = csvfile.rstrip('\n')
                csvfile = CSVFILELOC + csvfile
                list_csvfiles.append(csvfile)
                export_csvfile(csvfile)
        except FileExistsError:
            print('\nProblem with CSV files\n')


def export_csvfile(csvfile):
    db = mysql.connector.connect(
        host="localhost",
        user="devdavid",
        password="h3lpm3",
        database="CRASHDB"
        )

    with open(csvfile, 'r') as file:
        connCRASHDB = db.cursor()
        csv_data = csv.reader(file(csvfile))
        csv_data = csv_data.rstrip('\n')
        for row in csv_data:
            connCRASHDB.execute('INSERT INTO VSTATS (HOSTNAME, FREEMEM, BUFFER, CACHE, DATE)' 'VALUES("%s", "%s", "%s", "%s", "%s")', row)
        connCRASHDB.commit()
        connCRASHDB.close()
        print 
    file.close()

if __name__ == "__main__":
    main()
print()
print('Exit program\n')
exit(0)