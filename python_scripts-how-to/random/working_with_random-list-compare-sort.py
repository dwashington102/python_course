#!/usr/bin/env python3 
"""
Write a program that returns a list that contains only the elements
that are common between the lists (without duplicates). Make sure
your program works on two lists of different sizes.

Extras:

Randomly generate two lists to test this
Write this in one line of Python (don’t worry if you can’t figure
this out at this point - we’ll get to it soon)
"""

import random


def main():
    original_assignment()
    extra_credit()


def original_assignment():
    a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
    b = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    c = []

    for anum in a:
        if anum in b:
            if anum in c:
                pass
            else:
                c.append(anum)
        else:
            pass
    print(c)


def extra_credit():
    alist = []
    blist = []
    clist = []
    counta = random.randint(1, 20)
    countb = random.randint(1, 20)

    while counta > 0:
        a = random.randint(1, 10)
        alist.append(a)
        counta -= 1

    while countb > 0:
        b = random.randint(1, 10)
        blist.append(b)
        countb -= 1

    for anum in alist:
        if anum in blist:
            if anum in clist:
                pass
            else:
                clist.append(anum)

    print(f"Alist: {alist}")
    print(f"Blist: {blist}")
    print(f"Common Items in lists\n{clist}")
    clist.sort()
    print(f"Common Items Sorted in lists\n{clist}")


if __name__ == "__main__":
    main()
