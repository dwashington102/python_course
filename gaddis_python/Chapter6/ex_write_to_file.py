'''
Program write the integers (1-10) to a file (numbers.txt) in the same directory
'''

import os


# Import custom modules

# Define GLOBAL CONSTANTS

def main():
    os.system('clear')
    write_numbers()


def write_numbers():
    loopcount = 1
    try:
        outputfile = open('numbers.txt', 'w')
        while loopcount <= 10:
            str_loopcount = str(loopcount)
            outputfile.write(str_loopcount)
            outputfile.write('\n')
            loopcount += 1
        print('Completed writing to file.\n')
        outputfile.close()
    except FileNotFoundError:
        print('File not found')
        exit(1)
    

if __name__ == '__main__':
    main()
