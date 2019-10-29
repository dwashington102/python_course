'''
Progam will read in a  text file that contains values (dividend payouts).
The program will sum all values and print out a total value for dividend payouts
'''

import csv                  # Import csv module


# Define GLOBAL CONSTANTS
DISPLAY_HEADER = "="
DISPLAY_FOOTER = "-"

# Define Variables
#divends_lst = []                # Create an empty list


# When iterating over the lines of the file (/tmp/afile.txt), a list[] is created
# To sum the values of the lists - we have to take the 1st elememt of the list (element 0)
# convert the element to a float before adding the element to the total dividend
# NOTE:  If any 0 element contains a comma ",", Python will read the element as a string which
# cannot be converted to a float.  In order to avoid this issue we must use the replace() to
# remove unwanted commas

# Steps to create the csv file
# Login to Fidelity --> Download transactions for selected time frame --> save to csv file
# script reads each row of the csv to the variable "row"
# Each "row" variable is then checked to see if the text 'DIVIDEND' is found
# When 'DIVIDEND' is found the script extracts the dividend value using list[3]
# adds the value to the cumulating value "tot_div"


def display_header():
    print(DISPLAY_HEADER * 50)
    print('Contributions, Dividends, Fees')
    print(DISPLAY_FOOTER * 50)


def main(): 
    display_header()
    tot_div = 0.0                 # Set the total dividend payout to 0.00
    tot_contr = 0.0
    tot_fees = 0.0

    with open('history_2015.csv', 'r') as afile:
        row = csv.reader(afile, delimiter=',')
        for r in row:
            if 'DIVIDEND' in r:
                my_div = r[3]
                my_div = float(my_div.replace(',', ''))
                tot_div = tot_div + my_div
            elif 'CONTRIBUTION' in r:
                my_contr = r[3]    
                my_contr = float(my_contr.replace(',', ''))
                tot_contr = tot_contr + my_contr
            elif 'ADMINISTRATIVE FEES':
                my_fees = r[3]
                my_fees = float(my_fees.replace(',', ''))
                tot_fees = tot_fees + my_fees
            else:
                pass

    print('Total CONTRIBUTIONS 2015 - 2019 (YTD):\t ${:,.2f}'.format(tot_contr))
    print('Total Dividends 2015 - 2019 (YTD):\t ${:,.2f}'.format(tot_div))
    print('Total ADMIN FEES 2015 - 2019 (YTD):\t ${:,.2f}'.format(tot_fees))
    print()
    afile.close()


if __name__ == '__main__':
    main()

