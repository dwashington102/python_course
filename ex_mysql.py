import mysql.connector
import csv
from time import sleep


#Define GLOBAL CONSTANTS
EBCSV='/home/devdavid/data/EB.csv'


# Create the connection to the database
mydb = mysql.connector.connect(
    host = "localhost",
    user = "devdavid",
    passwd = "gettingugly",
    database = "mydb",
)

my_cursor = mydb.cursor()

#Create database
#my_cursor.execute("CREATE DATABASE mydb")

# Gather a list of databases
#my_cursor.execute("SHOW DATABASES")
#for db in my_cursor:
#    print(db[0])

# Create table statement in mysql:
'''
CREATE TABLE `mydb`.`dayinfo` (
  `RowNum` INT UNSIGNED NOT NULL,
  `Date` VARCHAR(10) NOT NULL,
  `Open` VARCHAR(10) NULL,
  `High` VARCHAR(10) NULL,
  `Low` VARCHAR(10) NULL,
  `Close` VARCHAR(10) NULL,
  `AdjClose` VARCHAR(10) NULL,
  `Volume` VARCHAR(45) NULL,
  PRIMARY KEY (`RowNum`));
'''
# Date,Open,High,Low,Close,Adj Close,Volume
# Creating a table
# Valid Statement
#my_cursor.execute("CREATE TABLE DAYINFO (Date VARCHAR(10), Open VARCHAR(10), High VARCHAR(10), Low VARCHAR(10), Close VARCHAR(10), AdjClose VARCHAR(10), Volume VARCHAR(20), RowNum INTEGER(10) AUTO_INCREMENT PRIMARY KEY)")

# Testing statement
#my_cursor.execute("CREATE TABLE dayinfo (RowNum INT(10) NOT NULL, Col1 VARCHAR(10), Col2 VARCHAR(10), PRIMARY KEY ('RowNum'))")

# Showing the tables in the database
#my_cursor.execute("SHOW TABLES")
#for table in my_cursor:
#    print(table)

#Manually inserting a row of data into the table
#sqlcmd = "INSERT INTO dayinfo (Date, Open, High, Low, Close, AdjClose, Volume) VALUES (%s, %s, %s, %s, %s, %s, %s)"
#record1 = ("2018-10-02", "36.770000", "37.000000", "34.130001", "34.340000", "34.340000", 491200)
#my_cursor.execute(sqlcmd, record1)
#mydb.commit()

#Inserting data by reading in the contents of a csv file:
try:
    sqlloadcsv= "LOAD DATA LOCAL INFILE '/home/devdavid/data/EB.csv' INTO TABLE DAYINFO FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (Date, Open, High, Low, Close, AdjClose, Volume)"  
except SystemError as genError:
    print('Error 1 ==== \t', genError)
    

print('DEBUG sqlloadcsv--->', sqlloadcsv)
sleep(5)

my_cursor.execute(sqlloadcsv)
try: 
    print('Data inserted and committed')
    mydb.commit()
    mydb.close()
except SystemError as genError:
    print('Error 2 ==== \t', genError)
    mydb.rollback()
    mydb.close()