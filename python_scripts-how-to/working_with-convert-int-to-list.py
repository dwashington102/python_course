#!/usr/bin/env python3


userguess = int(input("Enter 4-digit number: "))

print(f"Type: {type(userguess)}\n\tValue: {userguess}")

"""
map the int. to a string, and then to a list
"""
abclist = list(map(int, str(userguess)))
itemcount = 0

print(f"Type: {type(abclist)}\n\tValue: {abclist}")

for anum in abclist:
    print(f"DEBUG:  {type(abclist[itemcount])}")
    itemcount += 1

