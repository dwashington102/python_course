#!/usr/bin/env python3
'''
Script will print
99 bottles of beer on the wall
take 1 down pass it around...
98 bottles of beer on the wall
...
1 bottle of beer on the wall
No more bottles of beer on the wall
'''


from time import sleep

words = "bottles of beer on the wall"

for beer in range(99, -1, -1):
    if beer == 1:
        print(beer, "bottle of beer on the wall")
    elif beer == 0:
        print("No more bottles of beer on the wall")
    else:
        print(beer, words)
    # sleep(1)
