'''
Progam displays the contents of a file
'''

import os


# Import custom modules


# Define GLOBAL CONSTANTS


def main():
    do_work()

def do_work():
    try:
        my_file = open('numbers.txt', 'r') 
        for row in my_file:
            print(row, end='')
    except FileNotFoundError:
        print('File not Found')


if __name__ == '__main__':
    main()
