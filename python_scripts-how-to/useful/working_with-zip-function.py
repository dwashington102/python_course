#!/usr/bin/env python3
"""
Use the zip function to interate over 2 list
rather than the usual count=0...count += 1
"""

mynums = ("1", "2", "3")
mynames = ("David", "Melissa", "Ralph")

for num, name in zip(mynums, mynames):
    print(f"{name} is number {num}")

print("\n")
# Testing zip() against tuple
veggies = ["carrots", "turnips", "peas"]
fruits = ["apples", "grapes", "oranges"]

for veg, fruit in zip(veggies, fruits):
    print(f"Veggie: {veg}\tFruit: {fruit}")

