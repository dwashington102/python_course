#!/usr/bin/env python3
''' Lab #8
Step 1: Create flowchart / pseudocode and Python for a program
that displays course information.
Your program should continue to prompt the user for a course
number, and display the name of the course until a sentinel
value is entered.
Use a list of strings that contains the course names information.

Course Information:
Course Number       Course Name
1                   Yoga 1
2                   Yoga 2
3                   Children's Yoga
4                   Prenatal Yoga
5                   Senior Yoga
'''

# Define GLOBAL CONSTANTS
DISPLAY_SPACER = '*'
COURSE_LIST = ['Yoga 1', 'Yoga 2', "Children's Yoga", 'Prenatal Yoga',
               'Senior Yoga']


def display_header():
    print(DISPLAY_SPACER * 50)
    print("Course Schedule")
    print(DISPLAY_SPACER * 50)


def get_course_num():
    user_choice = 'y'
    while user_choice == 'y':
        try:
            u_number = int(float(input('Enter course number (1-5):  ')))
            if u_number <= 0 or u_number > 5:
                print('Invalid Course Number')
            else:
                display_course(u_number)
        except ValueError:
            print('Invalid Entry')
        user_choice = input('Do you want to try again (y/n):  ')


def display_course(u_number):
    a_course = COURSE_LIST[u_number - 1]
    print('Course Number ', u_number, 'is - ', a_course)


def main():
    display_header()
    get_course_num()


if __name__ == 'main':
    main()

main()
