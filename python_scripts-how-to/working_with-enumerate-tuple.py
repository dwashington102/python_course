#!/usr/bin/env python3

mytuple = ("apples", "oranges", 6.73, "security")

print(f"Type for mytuple: {type(mytuple)}")
for index, item in enumerate(mytuple):
    msg = "Index: {}\tValue: {}\tType: {}".format(index, mytuple[index],
                                                  type(mytuple[index]))
    print(msg)

