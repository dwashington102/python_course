#!/usr/bin/env python3

mytuple = ["apples", "oranges", 6.73, "security"]
count = 0

for i in mytuple:
    msg = "Index: {}\tValue: {}\tType: {}".format(count, mytuple[count], type(mytuple[count]))
    print(msg)
    count += 1

