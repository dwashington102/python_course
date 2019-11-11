import csv
import pandas as pd


# Define GLOBAL CONSTANTS
CSVFILE = '/home/david/Downloads/history.csv'
SPACER = "-"

# Read the CSV file into memory
with open(CSVFILE, 'r') as inputfile:
    row = csv.reader(inputfile)
    mydata = list(row)

# Create a pandas DataFrame in order to process the csv file.
# Setting the columns to the values seen below
df = pd.DataFrame(mydata, 
                  columns=["Date", "Fund", "Trade Type", "Amount", "Shares"])


print()
# Confirm the datatypes for the values of the dataframe
# object = string
dtype_before = df.dtypes
print(SPACER * 70, '\n'+ 'dtypes Before:\n')
print(dtype_before)

# In order to compute values in the dataframe is is necessary to convert datatype
# "objects" to floats using lambda
print()
print(SPACER * 70, '\n'+ 'dtypes After:\n')
df["Amount"]=df["Amount"].apply(lambda x: float(x.split()[0].replace(',', '')))
df["Shares"]=df["Shares"].apply(lambda x: float(x.split()[0].replace(',', '')))

# Confirm the datatypes for the values of the dataframe
dtype_after = df.dtypes
print(dtype_after)

# Confirm the max. value for data stored in the "Amount" column
# NOTE:  The settings will only print the data stored in the Amount column NOT the entire
# row.
maxcontr = df['Amount'].max()
mincontr = df['Amount'].min()

# Confirm the max. value for the data stored in the "Amount" column and PRINT the entire
# row
testmax = df.loc[df['Amount'].idxmax()]

# Print items
print()
print(SPACER * 70, '\n', 'Max/Min Contributions:\n')
print('Max Contribution: ${:,.2f}'.format(maxcontr))
print('Min Contribution: ${:,.2f}'.format(mincontr))
print('Test Max Contribution: ', testmax)

# Closing the file
inputfile.close()
