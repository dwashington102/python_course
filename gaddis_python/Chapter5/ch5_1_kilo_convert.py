'''
Program takes user input for a distance in kilometers and converts to distance in miles.
miles = kilometers * 0.6214
'''

import os

# Import custom modules

# Define GLOBAL CONSTANTS
KM_PER_MILE = 0.6214


def main():
    get_userinput()


def get_userinput():
    get_km = float(input('Distance in Kilometers: '))
    compute_miles(get_km)


def compute_miles(get_km):
    distance_miles = get_km * KM_PER_MILE
    print('{:,.2f} kilometers converts to {:,.2f} miles.'.format(get_km, distance_miles))

if __name__ == '__main__':
    main()
