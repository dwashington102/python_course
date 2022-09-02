#!/usr/bin/env python3

'''
Progam will read in a csv file that contains contributions, dividends, and fees
for an investment account.
The program will sum all values and print out a total value for each.
'''

import csv                 
import os                   
import re
from time import sleep


# Define GLOBAL CONSTANTS
DISPLAY_HEADER = "="    
DISPLAY_FOOTER = "-"    

# Define Variables


# When iterating over the lines of the file (/tmp/afile.txt), a list[] is created
# To sum the values of the lists - we have to take the 1st elememt of the list (element 0)
# convert the element to a float before adding the element to the total dividend
# NOTE:  If any 0 element contains a comma ",", Python will read the element as a string which
# cannot be converted to a float.  In order to avoid this issue we must use the replace() to
# remove unwanted commas

# Steps to create the csv file
# > Login to Fidelity --> Download transactions for selected time frame --> save to csv file
# > REMOVE HEADER INFORMATION FROM CSV FILE 
# script reads each row of the csv to the variable "row"
# Each "row" variable is then checked to see if the text 'DIVIDEND' is found
# When 'DIVIDEND' is found the script extracts the dividend value using list[3]
# adds the value to the cumulating value "tot_div"
#
# Syntax:
# Call the script using: python3 fidelity_history.py {history.csv}

def main():
    try:
        u_history = get_filename()
        compute_totals(u_history)
        get_daterange(u_history)
    except KeyboardInterrupt:
        print("\nUser terminate request received")
        exit(0)



def get_filename():    # Prompt the user for the path to the csv file
    os.system('clear')
    u_history = input('Enter the path and csv filename: ')
    # Confirm the file exists before starting to compute
    try:
        with open(u_history, 'r') as atest:
            # If file is found begin work
            # compute_totals(u_history)
            return u_history
            atest.close()
    except FileNotFoundError:
            # If file is not found exit(1)
        print('File not found: ', u_history)
        print()
        exit(1)


def display_header():
    print(DISPLAY_HEADER * 50)
    print('Contributions, Dividends, Fees')
    print(DISPLAY_FOOTER * 50)


def compute_totals(u_history): 
    display_header()              # Print the Header Information
    # Initial varibles used for totals to 0.0
    tot_div = 0.0                 
    tot_contr = 0.0              
    tot_fees = 0.0              

    # Misc. fee/transactions totals
    tot_credit = 0.0
    tot_loan=0.0
    tot_loan_repay = 0.0
    tot_loan_ori = 0.0
    tot_loan_fee = 0.0
    tot_cmv = 0.0

    # Xfer between funds totals
    tot_xout = 0.0
    tot_xin = 0.0

    # Lines where transaction type (Dividend, Contributions, etc.) were not found
    notFound=['']

    with open(u_history, 'r') as afile:
        row = csv.reader(afile, delimiter=',')
        for r in row:
            rowstring=str(r) # Converts r to string in order to use RE when searching for transaction type
            #print ('DEBUG >>> ', rowstring)
            #sleep(0.5)
            if re.search(r"Dividend", rowstring, re.IGNORECASE):   # Isolate DIVIDEND rows and total
                my_div = r[3]
                my_div = float(my_div.replace(',', ''))
                tot_div = tot_div + my_div
            elif re.search('Contribution', rowstring, re.IGNORECASE):    # Isolate CONTRIBUTION rows and total
                my_contr = r[3]    
                my_contr = float(my_contr.replace(',', ''))
                tot_contr = tot_contr + my_contr
            elif re.search('ADMINISTRATIVE FEES', rowstring, re.IGNORECASE):  # Isolate ADMINISTRATIVE FEES rows and total
                my_fees = r[3]
                my_fees = float(my_fees.replace(',', ''))
                tot_fees = tot_fees + my_fees
            elif re.search('REVENUE CREDIT', rowstring, re.IGNORECASE):  # Isolate REVENUE CREDIT rows and total
                my_credit = r[3]
                my_credit = float(my_credit.replace(',', ''))
                tot_credit = tot_credit + my_credit
            elif re.search('Loan Repayments', rowstring, re.IGNORECASE):  # Isolate Loan Repayments rows and total
                my_loan_repay = r[3]
                my_loan_repay = float(my_loan_repay.replace(',', ''))
                tot_loan_repay = tot_loan_repay + my_loan_repay
            elif re.search('Loan Origination', rowstring, re.IGNORECASE):   # Isolate Loan rows and total
                my_loan_ori = r[3]
                my_loan_ori = float(my_loan_ori.replace(',', ''))
                tot_loan_ori = tot_loan_ori + my_loan_ori
            elif re.search('Loan Setup Fee', rowstring, re.IGNORECASE):   # Isolate Loan rows and total
                my_loan_fee = r[3]
                my_loan_fee = float(my_loan_fee.replace(',', ''))
                tot_loan_fee = tot_loan_fee + my_loan_fee
            elif re.search('Loan', rowstring, re.IGNORECASE):  # Isolate Loan Repayments rows and total
                my_loan = r[3]
                my_loan = float(my_loan.replace(',', ''))
                tot_loan = tot_loan + my_loan
            elif re.search('Change in Market Value', rowstring, re.IGNORECASE):  # Isolate Change in Market Value rows and total
                my_cmv = r[3]
                my_cmv = float(my_cmv.replace(',', ''))
                tot_cmv = tot_cmv + my_cmv
            elif re.search('Exchange out', rowstring, re.IGNORECASE):  # Isolate Exchange out rows and total
                my_xout = r[3]
                my_xout = float(my_xout.replace(',', ''))
                tot_xout = tot_xout + my_xout
            elif re.search('Exchange In', rowstring, re.IGNORECASE):  # Isolate Exchange In rows and total
                my_xin = r[3]
                my_xin = float(my_xin.replace(',', ''))
                tot_xin = tot_xin + my_xin
            else:       # Ignore lines that do not contain the search strings
                #print('DEBUG >>> Reached Else Statement')
                notFound.append(r)
    afile.close()       # close opened csv file
    #get_lastline(u_history)   # Get the start and end dates from the csv file
    #get_daterange(u_history)

    print()
    print('Total CONTRIBUTIONS:\t ${:,.2f}'.format(tot_contr))
    print('Total Dividends:\t ${:,.2f}'.format(tot_div))
    print('Total ADMIN FEES:\t ${:,.2f}'.format(tot_fees))
    print()
    print(DISPLAY_FOOTER * 50)
    print('Misc. Transactions:')
    print('Total REVENUE CREDIT:  \t ${:,.2f}'.format(tot_credit))
    print('Total Loan:            \t ${:,.2f}'.format(tot_loan))
    print('Total Loan Repayments: \t ${:,.2f}'.format(tot_loan_repay))
    print('Total Loan Origination:\t ${:,.2f}'.format(tot_loan_ori))
    print('Total Loan Setup Fee:  \t ${:,.2f}'.format(tot_loan_fee))
    print(DISPLAY_FOOTER * 50)
    print('Xfer Between Funds:')
    print('Totat Exchange out:\t ${:,.2f}'.format(tot_xout))
    print('Totat Exchange In:\t ${:,.2f}'.format(tot_xin))

    print('\nMarket Value Change Sold Securities:\t ${:,.2f}'.format(tot_cmv))

#    print('\nDEBUG >>> Used only for debug purpose:')
#    print('\nLines where transaction type was not found', notFound)


def get_daterange(u_history):
    with open(u_history, 'r') as afile:
        datelist = []
        for row in afile:
            if re.match(r"\d", row):
                datelist.append(row)
            else:
                pass

        size_datelist = len(datelist)
        if size_datelist <= 0:
            print('No valid dates found')
        else:
            my_begin = datelist.pop(0)
            csv_enddate = re.sub(r',.*$', "", my_begin)
            csv_enddate = csv_enddate.strip("\n")

            my_end = datelist.pop()
            csv_startdate = re.sub(r',.*$', "", my_end)
            csv_startdate = csv_startdate.rstrip()
            print('Start Date:\t{}'.format(csv_startdate))
            print('End Date:\t{}'.format(csv_enddate))

if __name__ == '__main__':
    main()

