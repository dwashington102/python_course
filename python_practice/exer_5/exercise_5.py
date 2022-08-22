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
    do_work()


def do_work():
    random20 = randint(1, 20)
    random40 = randint(1, 40)
    alist = []
    blist = []
    commonset = set()
    for i in range(1, random20):
        aelement = randint(1, 10)
        alist.append(aelement)

    for i in range(1, random40):
        belement = randint(1, 10)
        blist.append(belement)

    print(f"A LIST: {alist}")
    print(f"B LIST: {blist}")

    for belement in blist:
        if belement in alist:
            commonset.add(belement)

    # Using list comprehension to replace for loop
    acommonset = [belement for belement in alist]
    acommonset.sort()
    result = [*set(acommonset)]

    print(f"\nCommon Elements in both lists added to a set:\n{commonset}")
    print(f"\nCommon Elements in both lists added to a list:\n{acommonset}")
    print(f"\nResult:\n{result}")
    print(f"Type = {type(result)}")

    # using list comprehension
    # to remove duplicated
    # from list
    res = []
    [res.append(belement) for belement in alist if belement not in res]
    res.sort()
    print(f"\nResult Remove Dupes ---> :{res}")
    print(f"\nType of: {type(res)}")


if __name__ == "__main__":
    main()
