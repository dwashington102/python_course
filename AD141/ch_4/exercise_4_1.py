#!/usr/bin/env python3

"""
Exercise 1
Write and test a function that is designed to validate input.
The function should prompt the user for a positive integer.
It should validate the information entered by the user is indeed a positive integer.
If number entered is valid, the function should return the number.
If the number entered is invalid, the function should return a zero (0) instead.
The application, not the function, should indicate with a message in the output each time an invalid entry is given.
"""

def main():
    getnum = get_int()
    if getnum < 0:
        print("Invalid Entry: 0")


def get_int():
    try:
        getnum = int(input("Enter number: "))
        if getnum > 0:
            print(f"Positive Number: {getnum}")
        return getnum
    except:
        raise


if __name__ == "__main__":
    main()
