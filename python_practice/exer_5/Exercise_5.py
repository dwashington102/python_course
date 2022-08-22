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

from random import randint

a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
b = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

DEBUGTXT = "DEBUG >>> {}"


def main():
    gen_alist
    gen_blist
    # check_elements(alist, blist)


def gen_alist():
    arandom = randint(1, 10)
    print(f"DEBUG >>> {arandom =}")
    alist = []
    for i in range(1, alist):
        arandnum = randint(1, arandom)
        alist.append[arandnum]
    print(f"DEBUG >>> {alist =}")
    # return alist


def gen_blist():
    brandom = randint(1, 15)
    print(f"DEBUG >>> {brandom =}")
    blist = []
    for i in range(1, blist):
        brandnum = randint(1, brandom)
        blist.append[brandnum]
    print(f"DEBUG >>> {blist =}")
    # return blist


def check_elements(alist, blist):
    for belement in blist:
        if belement in alist:
            print(f"YES {belement} is in both list")


if __name__ == '__main__':
    main()
