#!/usr/bin/env python3
"""
Examples of working with the len function
- len function against these objects
--> str, lists, tuples
"""

mystring = "Hello World"
fruits = ["apples", "oranges", "grapes", "olives"]
animals = ("cat", "dog", "mouse", "turtle")

for char in mystring:
    print(char)

for fruit in fruits:
    print(fruit)

for i in animals:
    print(i)

# Running len function against a number
mynumber = 10 * 23023892
print(mynumber, " is type ", type(mynumber))
print("Length of mynumber: ", len(str(mynumber)))
