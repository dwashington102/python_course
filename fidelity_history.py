'''
Progam will read in a csv file that contains contributions, dividends, and fees
for an investment account.
The program will sum all values and print out a total value for each.
'''

import csv                 
import os                   
import re


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

def main():
    get_filename()


def get_filename():    # Prompt the user for the path to the csv file
    os.system('clear')
    u_history = input('Enter the path and csv filename: ')
    # Confirm the file exists before starting to compute
    try:
        with open(u_history, 'r') as atest:
            # If file is found begin work
            compute_totals(u_history)
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
    tot_loan = 0.0
    tot_cmv = 0.0

    # Xfer between funds totals
    tot_xout = 0.0
    tot_xin = 0.0

    with open(u_history, 'r') as afile:
        row = csv.reader(afile, delimiter=',')
        for r in row:
            if 'DIVIDEND' in r:   # Isolate DIVIDEND rows and total
                my_div = r[3]
                my_div = float(my_div.replace(',', ''))
                tot_div = tot_div + my_div
            elif 'CONTRIBUTION' in r:    # Isolate CONTRIBUTION rows and total
                my_contr = r[3]    
                my_contr = float(my_contr.replace(',', ''))
                tot_contr = tot_contr + my_contr
            elif 'ADMINISTRATIVE FEES' in r:  # Isolate ADMINISTRATIVE FEES rows and total
                my_fees = r[3]
                my_fees = float(my_fees.replace(',', ''))
                tot_fees = tot_fees + my_fees
            elif 'REVENUE CREDIT' in r:  # Isolate REVENUE CREDIT rows and total
                my_credit = r[3]
                my_credit = float(my_credit.replace(',', ''))
                tot_credit = tot_credit + my_credit
            elif 'Loan Repayments' in r:  # Isolate Loan Repayments rows and total
                my_loan = r[3]
                my_loan = float(my_loan.replace(',', ''))
                tot_loan = tot_loan + my_loan
            elif 'Change in Market Value' in r:  # Isolate Change in Market Value rows and total
                my_cmv = r[3]
                my_cmv = float(my_cmv.replace(',', ''))
                tot_cmv = tot_cmv + my_cmv
            elif 'Exchange out' in r:  # Isolate Exchange out rows and total
                my_xout = r[3]
                my_xout = float(my_xout.replace(',', ''))
                tot_xout = tot_xout + my_xout
            elif 'Exchange In' in r:  # Isolate Exchange In rows and total
                my_xin = r[3]
                my_xin = float(my_xin.replace(',', ''))
                tot_xin = tot_xin + my_xin
            else:       # Ignore lines that do not contain the search strings
                pass
    afile.close()       # close opened csv file
    #get_lastline(u_history)   # Get the start and end dates from the csv file
    get_daterange(u_history)

    print()
    print('Total CONTRIBUTIONS:\t ${:,.2f}'.format(tot_contr))
    print('Total Dividends:\t ${:,.2f}'.format(tot_div))
    print('Total ADMIN FEES:\t ${:,.2f}'.format(tot_fees))
    print()
    print(DISPLAY_FOOTER * 50)
    print('Misc. Transactions:')
    print('Total REVENUE CREDIT:\t ${:,.2f}'.format(tot_credit))
    print('Total Loan Repayments:\t ${:,.2f}'.format(tot_loan))
    print('Market Value Change:\t ${:,.2f}'.format(tot_cmv))
    print(DISPLAY_FOOTER * 50)
    print('Xfer Between Funds:')
    print('Totat Exchange out:\t ${:,.2f}'.format(tot_xout))
    print('Totat Exchange In:\t ${:,.2f}'.format(tot_xin))


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
            csv_startdate = re.sub(r',.*$', "", my_begin)
            csv_startdate = csv_startdate.strip("\n")

            my_end = datelist.pop()
            csv_enddate = re.sub(r',.*$', "", my_end)
            csv_enddate = csv_enddate.rstrip()
            print('End Date:\t{}'.format(csv_enddate))
            print('Start Date:\t{}'.format(csv_startdate))

if __name__ == '__main__':
    main()

print('\nend of program\n')

