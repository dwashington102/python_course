'''
Program  will read csv file that contains contributions, dividends, and fees
for an investment account.  The values are then inserted into a MySQL database

Manual Steps:
1) Download csv file from Fidelity

Database Table Columns
describe FIDELITY;
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| DATE       | datetime    | NO   |     | NULL    |       |
| INVESTMENT | varchar(45) | YES  |     | NULL    |       |
| TRANSTYPE  | varchar(45) | YES  |     | NULL    |       |
| AMOUNT     | varchar(45) | YES  |     | NULL    |       |
| SHARES     | int(11)     | YES  |     | NULL    |       |
+------------+-------------+------+-----+---------+-------+

CSV file header and content format:
Date,Investment,Transaction Type,Amount,Shares/Unit
11/15/2019,VANG SM CAP IDX INST,CONTRIBUTION,"122.36","1.587"
11/15/2019,VANG PRIMECAP CORE,CONTRIBUTION,"122.36","4.228"
'''

# Import common modules
import os
from pathlib import Path
import time

# Modules for csv and database operations
import csv
import pandas as pd
import sqlalchemy
import pymysql

# Custom modules
from clear_screen import clear


# Define GLOBAL CONSTANTS
HOMEDIR = str(Path.home())
CSVFILELOC = HOMEDIR + '/databases/data/'

def main():
    clear()
    get_csvfile()

#Function opens the csv file for reading and calls the export_csvfile().
def get_csvfile():
    csvfile_hist = CSVFILELOC + 'history_ytd.csv'
    try:
        with open(csvfile_hist, 'r') as datafile:
            #print('DEBUG >>> Data file: ', datafile)
            export_csvfile(datafile)
    except FileNotFoundError as err:
        print('File ', csvfile_hist, ' NOT FOUND')
        print(err)
        exit(1)

# Function defines db connection engine and exports contents of csv file
def export_csvfile(datafile):
    try:
        engine = sqlalchemy.create_engine('mysql+pymysql://x1user:cxgg65$.#@localhost/TRANSACTIONS')
    except ConnectionError as dbconnErr: 
        print('Database connection failure')
        print(dbconnErr)
    
    df = pd.read_csv(datafile, sep=',')

    # Column names in the csv file do not match database table columns. Using the df.rename() allows
    # allows the inserts to complete.
    # Format:  columns = {'csv column' : 'Table column', 'csv column' : 'Table column'}, inplace=True)
    df.rename(columns = {'Date' : 'DATE', 'Investment' : 'INVESTMENT', 'Transaction Type' : 'TRANSTYPE', 'Amount' : 'AMOUNT', 'Shares/Unit' : 'SHARES'}, inplace=True)

    try:
        df.to_sql(name='FIDELITY', con=engine, index=False, if_exists='append')
    except Exception as inErr:
        print('Insert failed')
        print(inErr)
        exit(2)


if __name__ == '__main__':
    main()
