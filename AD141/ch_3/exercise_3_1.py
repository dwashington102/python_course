#!/usr/bin/env python3

"""
Given the following two lists:

first = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
second = ["day", "day", "sday", "nesday", "rsday", "day", "urday"]

Concatenate the two lists by index into a new list that, when printed,
looks as follows:
["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
"""


first = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
second = ["day", "day", "sday", "nesday", "rsday", "day", "urday"]

print(f"DEBUG >>> {type(first) =}")
print(f"DEBUG >>> {type(second) =}")

mylist = []

for index in enumerate(first):
    print(index)

