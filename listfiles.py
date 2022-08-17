#!/usr/bin/env python3
"""
Program will gather a list of the files and subdirectories in the current directory
prints out the filename and "True"  --> if the item is a file 
prints out the directory name and "is a directory"  --> if the item is a directory
"""

import os
from os import path
# Create an empty list and then add the files/subdirectories in the current directory into the list
mydirlist = []
mydirlist = os.listdir()


def main():
    myloop()
    print(f"Type mydirlist = {type(mydirlist)}")

# Look  throught the list (mydirlist).  Print only the "files", ignore the subdirectories
# The loopcount variable is used for a counting the iterations through list(mydirlist)
# output example:
#1: striphttp.py 	 True
#2: future_value.py 	 True
#3: csv_2_list.py 	 True
#4: csv_panda_test.py 	 True


def myloop():
    filemsg = "Entry {}\t{}\t{}"
    loopcount = 1
    for myfile in mydirlist:
        myfile = myfile.rstrip()
        ftype = str(path.isfile(myfile))
        if ftype:
            loop = str(loopcount)
            print(f"{loop}: {myfile}\t {ftype}")
            loopcount += 1
        else:
            print(f"{ftype =}")

if __name__ == '__main__':
    main()
