#!/usr/bin/env python3
import random


def set_mynum():
    get_mynum = random.randint(1, 50)
    print("DEBUG: >>> get_mynum: {}".format(get_mynum))
    return get_mynum


def print_hello(randomNum):
    print("DEBUG: >>> entered print_hello")
    print("What is my number: ", randomNum, "That's it")
    # print("What is my number: ", get_mynum, "That's it")


def main():
    randomNum = set_mynum()
    print_hello(randomNum)


if __name__ == "__main__":
    main()
    print("Leaving...")
