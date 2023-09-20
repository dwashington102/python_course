import mysql.connector as MySQL
import os
import random
import time

from csv import reader, writer
from mysql.connector import errorcode

conn = MySQL.connect(
    host='localhost',
    database='CRASHDB',
    user='devdavid',
    password='WHATISPASSWORD'
    )
cur = conn.cursor()
cur.execute('DROP TABLE IF EXISTS VSTATS')

DB_NAME = 'CRASHDB'
TABLES = {}

"""
See url: https://www.youtube.com/watch?v=4N5ykIF1vU4

-create table statement taken from mysql workbench
CREATE TABLE `CRASHDB`.`VSTATS` (
  `RowID` INT NOT NULL AUTO_INCREMENT,
  `HostId` VARCHAR(45) NOT NULL,
  `FREEMEM` INT NULL,
  `CACHE` INT NULL,
  `BUFFER` VARCHAR(45) NULL,
  PRIMARY KEY (`RowID`));
"""

TABLES['VSTATS'] = (
    "CREATE TABLE `VSTATS`("
    "`RowID` INT(5) NOT NULL AUTO_INCREMENT,"
    "`HOSTNAME` varchar(45) NOT NULL,"
    "PRIMARY KEY(`RowID`)" # In testing setting Primary Key could not be included when creating column
    ") ENGINE=innoDB")   #Storage engine of MySQL is innoDB


for table_name in TABLES:
    table_description = TABLES[table_name]
    try:
        print("Creating table {}: ".format(table_name), end='')
        cur.execute(table_description)
    except MySQL.Error as err:
        if err == errorcode.ER_TABLE_EXISTS_ERROR:
            print('Table already exists')
        else:
            print(err.msg)
    else:
        print("Success")
