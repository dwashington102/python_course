#!/usr/bin/env python3
"""
Ask the user for a number. Depending on whether the number is even
or odd, print out an appropriate message to the user. Hint: how does
an even / odd number react differently when divided by 2?

Extras:
-   If the number is a multiple of 4, print out a different message.

-   Ask the user for two numbers: one number to check (call it num)
    and one number to divide by (check). If check divides evenly into
    num, tell that to the user. If not, print a different appropriate
    message.
"""


def main():
    getnum = getinput_1()
    getmod, getmod4 = compute_getnum(getnum)
    evenodd(getnum, getmod, getmod4)


def getinput_1():
    """
    Request user input an integer
    """
    try:
        getnum = int(input("enter number: "))
    except ValueError as err:
        print(f"Incorrect integer received {err}")
        exit(1)
    return getnum


def compute_getnum(getnum):
    getmod = getnum % 2
    getmod4 = getnum % 4
    return (getmod, getmod4)


def evenodd(getnum, getmod, getmod4):
    if getmod4 == 0:
        print(f"{getnum} is multiple of 4")
    elif getmod == 0:
        print(f"{getnum} is even")
    else:
        print(f"{getnum} is odd")

    try:
        num = int(input("Check number: "))
        check = int(input("Divide by number: "))
    except ValueError as err:
        print(f"Incorrect integer received {err}")

    result = num % check
    if result == 0:
        print(f"{check} divides evenly into {num}")
    else:
        print(f"{check} does not divide evenly into {num}")


if __name__ == "__main__":
    main()
