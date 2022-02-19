#!/usr/bin/env python3
import random

def set_mynum():
    get_mynum=random.randint(1,50)
    print('DEBUG: >>>', get_mynum)

def print_hello():
    print('DEBUG: >>> entered print_hello')
    print("What is my number: ", get_mynum, "That's it")

def main():
    set_mynum()

if __name__ == "__main__":
    main()
    print("Leaving...")
exit(0)
