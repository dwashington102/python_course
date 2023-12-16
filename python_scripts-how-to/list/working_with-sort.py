#!/usr/bin/env python3


# Gather a list of file names
# mylist = [1.txt, 2.txt, 3.txt, 11.txt, 22.txt]
#
# Printing mylist results in this output
# 1.txt, 11.txt, 2.txt, 22.txt


mylist = ["1aaa.txt", "2.txt", "3aaa.txt", "aa11.txt", "22.txt"]
print(f"BEFORE: {mylist}")

mylist.sort(key=lambda f: int(''. join(filter(str. isdigit, f))))
print(f"AFTER: {mylist}")
