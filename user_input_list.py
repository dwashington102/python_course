'''
Step 1: Create flowchart / pseudocode and Python for a program that stores numbers in an
array. 

Program allows a user to enter 12 numbers.
The numbers are to be stored in an array.

After all of the numbers have been entered by the user (and stored), the program
displays all of the numbers (in the order they were entered), as well as the largest
number and the smallest number.
'''

from os import system
import random


# Define GLOBAL CONSTANTS
MAX_ENTRY = 12
GRAPH_BAR = "#"


def get_numbers():
    numlist = []
    loopcount =  1
    while loopcount <= MAX_ENTRY:
        #u_getnum = int(float(input('Enter Number: ')))
        u_getnum = random.randint(1,100)
        numlist.append(u_getnum)
        loopcount += 1
    compute_numlist(numlist)


def compute_numlist(numlist):
    a_min = min(numlist)
    a_max = max(numlist)
    print()
    print('Full List of Numbers: ', numlist)
    numlist.sort()
    print('Sort List of Numbers: ', numlist)
    print()

    print('Min. Value: ', a_min)
    print(GRAPH_BAR * a_min)

    print('Max. Value: ', a_max)
    print(GRAPH_BAR * a_max)
    print()


def main():
    system('clear')
    get_numbers()

if __name__ == '__main__':
    main()


