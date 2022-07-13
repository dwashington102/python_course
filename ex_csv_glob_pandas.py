"""
Progam gathers a list of files (vmstat*csv) from the $HOME/databases/sqlite_db/csv_files directory.
Iterates though the list and inserts data from the file(s) into the table VSTATS at the database
testdb2.
"""

import os
import pandas as pd
import sqlalchemy
import pymysql

from glob import glob
from  pathlib import Path
from time import sleep

HOMEDIR = str(Path.home())
CSVFILELOC = HOMEDIR + '/databases/sqlite_db/csv_files/'

filenames = glob(CSVFILELOC + 'vmstat*.csv')
engine = sqlalchemy.create_engine('mysql+pymysql://devdavid:password@localhost:3306/testdb2')

for f in filenames: 
    print(f)
    try:
        df = pd.read_csv(f, sep=':')
        df.to_sql(name='VSTATS', con=engine, index=False, if_exists='append')
    except Exception as insert_error:
        print('Error Inserting Data')
        print(insert_error)
