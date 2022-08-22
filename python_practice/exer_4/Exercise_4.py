#!/usr/bin/env python3

"""
Create a program that asks the user for a number and then prints out a
list of all the divisors of that number. (If you don’t know what a
divisor is, it is a number that divides evenly into another number.
For example, 13 is a divisor of 26 because 26 / 13 has no remainder.)
remainder
"""


def main():
    get_unumber = user_input()
    do_work(get_unumber)


def user_input():
    try:
        get_unumber = int(input("Print Enter an Integer:  "))
    except Exception:
        raise
    return get_unumber


def do_work(get_unumber):
    xlist = range(1, get_unumber, 1)
    for element in xlist:
        answer = get_unumber % element
        if answer == 0:
            print(f"{element} is a divisor of {get_unumber}")


if __name__ == "__main__":
    main()
