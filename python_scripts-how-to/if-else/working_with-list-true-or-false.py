#!/usr/bin/env python3
"""
Script provides an example of determining if
a list contains a value (TRUE) or
a list is empty (FALSE)
"""

import glob
import os

os.chdir("/tmp")
txtlist = glob.glob("*.txt")

if txtlist:
    print("TRUE: txtlist contains at least 1 element")
else:
    print("FALSE: txtlist is empty")

