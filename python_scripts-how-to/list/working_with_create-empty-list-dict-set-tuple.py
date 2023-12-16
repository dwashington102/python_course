#!/usr/bin/env python3

"""
Creating empty list, dict, set, and tuple
"""

mylist = []
mydict = {}
myset = set()
mytuple = ()

debuginfo = "DEBUG fmt {} >>"

print(f"mylist >>> {debuginfo.format(type(mylist))}")
print(f"mydict >>> {debuginfo.format(type(mydict))}")
print(f"myset >>>  {debuginfo.format(type(myset))}")
print(f"mytuple >>> {debuginfo.format(type(mytuple))}")

