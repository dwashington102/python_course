import os


# Import custom modules
from clear_screen import clear


# Define GLOBAL CONSTANTS
CALPERMIN = 4.2

def main():
    clear()
    count_calories()


def count_calories():    
loopcount = 10
while loopcount <= 30:
    totcalories = loopcount * CALPERMIN
    print('Total Calories burned for {} minutes: {:.2f}'.format(loopcount,totcalories))
    loopcount += 5


if __name__ == '__main__':
    main()



