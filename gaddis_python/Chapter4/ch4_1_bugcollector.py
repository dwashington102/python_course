import os

# Import custom modules

# Define GLOBAL CONSTANTS
TOTAL_DAYS = 5



loopcount = 1
tot_bugscollected = 0

while loopcount <= TOTAL_DAYS:
   print('Entry for Day:', loopcount)
   try:
       collected_bugs = int(float(input('How many bugs collected: ')))
       loopcount += 1
       tot_bugscollected = tot_bugscollected + collected_bugs

   except ValueError:
       print('\nInvalid Value Entered\n')


print('\nTotal Bugs Collected Over 5 Days: ', end='')
print(tot_bugscollected)


