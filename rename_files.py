#!/usr/bin/env python3
"""
Although this works, there is a major flaw.
Example:
    In a directory there are files names 1.txt, 2.txt through 12.txt
    The os.listdir output will list the files in this order
    ['1.txt', '10.txt', '11.txt', '12.txt', '2.txt', '3.txt'...]

    The script uses count=0, increments by 1, for each file that needs
    to be renamed.
    This means when renaming the list this takes place:
        1.txt  becomes 1.txt
        10.txt becomes 2.txt
        11.txt becomes 3.txt
        2.txt  becomes 4.txt
        3.txt  becomes 5.txt <---here is the problem,
        the original 3.txt was overwritten when we renamed
        11.txt.  So now we are renaming 3.txt (originally 11.txt)
"""

import os
import sys


def main():
    userdir = getdir()
    listfiles = getfiles(userdir)
    searchpattern = getext()
    do_work(listfiles, searchpattern, userdir)


def getdir():
    print("\n")
    """
    Request directory from user that contains the files that will
    be renamed.
    Exit Codes:
        1 - Directory does not exist
        2 - User does not have permission to access directory
    """
    userdir = str(input("Input directory name: "))
    try:
        os.chdir(userdir)
        print(f"Successfully set current working dir to {userdir}")
    except FileNotFoundError as efnf:
        print(f"FAILED --- {efnf} for directory {userdir}")
        sys.exit(1)
    except PermissionError as eperm:
        print(f"FAILED -- {eperm} for directory {userdir}")
        sys.exit(2)
    return (userdir)


def getfiles(userdir):
    """
    Build a list that contains the files in the directory
    Exit Codes:
        20 - The directory is empty
    """
    print("\n")
    listfiles = os.listdir()
    if len(listfiles) <= 0:
        print(f"Directory {userdir} is empty")
        sys.exit(20)
    return (listfiles)


def getext():
    """
    Get file extension from user
    Exit Codes:

    """
    userext = str(input("Input File Ext.: "))
    return (userext)


def do_work(listfiles, searchpattern, userdir):
    count = 0
    orderlist = sorted(listfiles)
    print(f"DEBUG >>> {orderlist}")
    sys.exit(0)
    for afile in orderlist:
        ftype = str(os.path.isfile(afile))
        if ftype == 'True':
            if searchpattern in afile:
                count += 1
                # print(f"DEBUG >>> filename: {afile} count: {count}")
                newname = str(count) + "." + searchpattern
                print(f"RENAME {afile} to {newname}")
                try:
                    os.rename(afile, newname)
                except PermissionError as eperm:
                    print(f"FAILED -- {eperm} for file {userdir}")
        else:
            print(f"SKIPPING DIR {afile}")

    if count == 0:
        print(f"No files with ext. {searchpattern}"
              "found in the directory {userdir}")


if __name__ == '__main__':
    main()
