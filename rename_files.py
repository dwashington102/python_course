#!/usr/bin/env python3
"""
"""

import os
import re
import sys


def main():
    try:
        defaultdir = currentdir()
        if defaultdir == "n":
            userdir = getdir()
        else:
            userdir = defaultdir
            listfiles = getfiles(userdir)
            searchpattern = getext()
            do_work(listfiles, searchpattern, userdir)
    except KeyboardInterrupt as ke:
        print("\nUser Interrupt received...exit(0)")
        sys.exit(0)


def currentdir():
    mydir = os.getcwd()
    print(f"Current Directory: {mydir}")
    defaultdir = input("Use current directory (y/n): ")
    return(defaultdir)


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
    orderlist = listfiles.sort(key=lambda f: int(''. join(filter(str. isdigit, f))))
    listfiles.sort(key=lambda f: int(''. join(filter(str. isdigit, f))))
    for afile in listfiles:
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
