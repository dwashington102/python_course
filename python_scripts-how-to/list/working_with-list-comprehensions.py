#!/usr/bin/env python3

alist = [1, 2, 3, 4, 5]
blist = [3, 4, 10, 12, 11]

commonlist = [ blist for blist in alist ]

DEBUG = "alist={}\nblist={}"

print(DEBUG.format(alist, blist))
print(commonlist)
