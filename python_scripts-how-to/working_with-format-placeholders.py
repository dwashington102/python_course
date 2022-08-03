#!/usr/bin/env python3

'''
Using the format() can help writing DRY code
'''

# Old Method
user1 = input('Enter UserName1: ')
user2 = input('Enter UserName2: ')
user3 = input('Enter UserName3: ')

print(user1, user2, user3)

# New Method using format method
getuser = "Enter UserName{}"

user1 = input(getuser.format("1: "))
user2 = input(getuser.format("2: "))
user3 = input(getuser.format("3: "))

print(user1, user2, user3)
