'''
Progam will read in a  text file that contains values (dividend payouts).
The program will sum all values and print out a total value for dividend payouts
'''

import csv                  # Import csv module




divends = []                # Create an empty list
tot_div = 0.0                 # Set the total dividend payout to 0.00


# When iterating over the lines of the file (/tmp/afile.txt), a list[] is created
# To sum the values of the lists - we have to take the 1st elememt of the list (element 0)
# convert the element to a float before adding the element to the total dividend

# NOTE:  If any 0 element contains a comma ",", Python will read the element as a string which
# cannot be converted to a float.  In order to avoid this issue we must use the replace() to 
# remove unwanted commas

with open('/tmp/afile.txt', 'r') as afile:
    row = csv.reader(afile, delimiter='\n')
    for r in row:
        my_div = r[0]
        my_div = float(my_div.replace(',', ''))
        tot_div = tot_div + my_div

print('Total Dividends YTD: ${:,.2f}'.format(tot_div))