'''
Program will ask user for the speed of a vehicle (in miles per hour)
and the number of hours traveled
distance = speed * time
'''

# Import required modules
import os

# Import custom modules

# Define GLOBAL CONSTANTS

def main():
    get_speed_and_hours()


def get_speed_and_hours():
    try:
        u_speed = int(float(input('Enter Speed (mph): ')))
        u_hours = int(input('Enter Hours: '))
        compute_distance(u_speed,u_hours)
    except ValueError:
        print('Invalid Value Entered')


def compute_distance(u_speed,u_hours):
    print('Hour\t\tDistance Traveled')
    print('-' * 30)
    loopcount = 1
    while loopcount <= u_hours:
        total_distance = u_speed * loopcount
        print(loopcount, '\t\t', total_distance)
        loopcount += 1


if __name__ == '__main__':
    main()
