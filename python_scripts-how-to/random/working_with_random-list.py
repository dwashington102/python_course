#!/usr/bin/env python3
from random import randint


def main():
    create_list()


def create_list():
    alist = []
    blist = []
    counta = randint(1, 10)
    countb = randint(1, 10)

    while counta > 0:
        a = randint(1, 10)
        alist.append(a)
        counta -= 1

    while countb > 0:
        b = randint(1, 10)
        blist.append(b)
        countb -= 1

    print(f"List A: {alist}")
    print(f"List B: {blist}")


if __name__ == "__main__":
    main()
