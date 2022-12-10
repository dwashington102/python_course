#!/usr/bin/env python3
"""
Coding practice taken from
https://www.practicepython.org/exercise/2014/07/05/18-cows-and-bulls.html

Randomly generate a 4-digit number. Ask the user to guess a 4-digit
number. For every digit that the user guessed correctly in the
correct place, they have a “cow”. For every digit the user guessed
correctly in the wrong place is a “bull.” Every time the user makes
a guess, tell them how many “cows” and “bulls” they have. Once the
user guesses the correct number, the game is over. Keep track of
the number of guesses the user makes throughout teh game and tell the
user at the end.
"""

import colorama
from random import randint
import sys


def main():
    print("Welcome to the Cows and Bulls Game")
    print('\n"COWS" = correct number guessed in the correct position')
    print('"BULLS" = correct number guessed but NOT in the correct position')
    print("\nTo exit game before random number is correctly guessed")
    print("Use ctrl-c\n")
    try:
        mynum = set_num()
        get_guess(mynum)
    except KeyboardInterrupt:
        print("\nCtrl-c received from user...exit(0)")
        print(f"Random Number was {mynum}")
        sys.exit(0)


def set_num():
    # Set the 4-digit random number
    mynum = randint(1000, 9999)
    print("\nRandon Number Set...")
    return (mynum)


def get_guess(mynum):
    # Function allows user to attempt to guess the 4-digit random number
    userguess = 0
    totalguess = 1
    cows = 0
    bulls = 0
    while userguess != mynum:
        userguess = int(input(f"Guess #{totalguess} - Enter 4-digit number: "))
        if userguess < 1000 or userguess > 9999:
            print("Guess must be between 1000 and 9999\n")
        else:
            totalguess += 1
            compare_guess(mynum, userguess, totalguess, cows, bulls)


def compare_guess(mynum, userguess, totalguess, cows, bulls):
    green = colorama.Fore.GREEN
    yellow = colorama.Fore.YELLOW
    normal = colorama.Fore.RESET
    if userguess == mynum:
        print(f"\nSuccessfully guessed number {mynum}."
              f"\n\tTotal Attempts: {totalguess - 1}")
        sys.exit(0)

    mynumlist = list(map(int, str(mynum)))
    guesslist = list(map(int, str(userguess)))
    # Next 2 lines are for debug ONLY
    # print(f"\nDEBUG >>> mynumlist type: {type(mynumlist)}\t{mynumlist}")
    # print(f"DEBUG >>> guesslist type: {type(guesslist)}\t{guesslist}")

    itemcount = 0
    cows = 0
    bulls = 0

    for anum in guesslist:
        if anum in mynumlist:
            # print(f"DEUBG >>> {anum} found in mynumlist")
            if guesslist[itemcount] == mynumlist[itemcount]:
                cows += 1
            else:
                bulls += 1
        else:
            pass
        itemcount += 1
    print(green + f"Total Cows: {cows}\r")
    print(yellow + f"\tTotal Bulls: {bulls}\n")
    print(normal)


if __name__ == "__main__":
    main()
