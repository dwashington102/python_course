# Import the required modules
from  pathlib import Path
import os

# 
import time

# Modules for csv and database operations
import csv
import pandas as pd
from pandas.io import sql
from sqlalchemy import create_engine


# Define GLOBAL CONSTANTS
HOMEDIR = str(Path.home())
CSVFILELOC = HOMEDIR + '/sqlite_db/csv_files/'

def main():
    get_csvfiles()


# Step through list of csv files in the given USERS $HOME/sqlite_db/csv_files path
def get_csvfiles():
    for (read, directory, file) in os.walk(CSVFILELOC):
        try: 
            for csvfile in file:
                csvfile = csvfile.rstrip('\n')
                csvfile = CSVFILELOC + csvfile
                print('Filename being processed...\t', csvfile)
                time.sleep(2)
                export_csvfile(csvfile) # Pass a single csv file to be processed as a df for pandas.
        except FileExistsError:
            print('\nProblem with CSV files\n')


def export_csvfile(csvfile):
    df = pd.read_csv(csvfile, sep=':')
    #df = pd.read_csv(csvfile, columns=['HOSTNAME', 'FREEMEM', 'BUFFER', 'CACHE', 'DATE'])
    #print(df)

    engine = create_engine('mysql://devdavid:h3lpm3@localhost/CRASHDB')
    count = db.engine.

if __name__ == "__main__":
    main()

print()
print('Exit program\n')
exit(0)