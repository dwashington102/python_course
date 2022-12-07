#!/usr/bin/env python3


setnum = ["1", "3", "6", "9"]
myguess = ["1", "2", "4", "3"]
itemcount = 0

for anum in setnum:
    if anum in myguess[itemcount]:
        print(f"anum in both sets: {anum}")
    itemcount += 1
