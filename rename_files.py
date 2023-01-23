#!/usr/bin/env python3
"""
Script allows user to input extension type (old), select new extension type,
and rename all files in a directory using the old extension type to
use the new extension type.


Exit Codes:
101 - getdir(): Directory not found
102 - getdir(): Permission denied when attempting to cd to directory
103 - get_platform(): Attempt to run script on non-Linux device
120 - getfiles(): cwd is empty

"""

import argparse
import os
import sys
import pprint


def main():
    extnew=""
    extold=""

    parser = argparse.ArgumentParser(
        description='Script renames files in a directory replace the'
        ' existing extension with the new extension given at runtime.'
    )
    parser.add_argument(
        "-d", "--dir",
        metavar="", type=str,
        help="Directory location", required=True
    )

    parser.add_argument(
        "-o", "--old",
        metavar="", type=str,
        help="Current file ext. type", required=True
    )

    parser.add_argument(
        "-n", "--new",
        metavar="", type=str,
        help="New file ext. type", required=True
    )

    args = parser.parse_args()

    userdir = args.directory
    oldext = args.old
    newext = args.new

    pprint.pprint(userdir)
    print(userdir)
    pprint.pprint(oldext)
    print(oldext)
    pprint.pprint(newext)
    print(newext)
    sys.exit(0)


    get_platform()
    try:
        userdir = os.getcwd()
        print(f"Current Directory: {userdir}")

        defaultdir = currentdir()
        if defaultdir == "n":
            userdir = getdir()

        listfiles = getfiles(userdir)
        searchpattern = getext()
        newext = getnewext()
        do_work(listfiles, searchpattern, userdir, newext)
    except KeyboardInterrupt:
        print("\nUser Interrupt received...exit(0)")
        sys.exit(0)


def get_platform():
    linuxplat = sys.platform
    if linuxplat != 'linux':
        print("\nScript must be ran on Linux device...exit(103)")
        sys.exit(103)


def currentdir():
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
        120 - The directory is empty
    """
    print("\n")
    listfiles = os.listdir()
    if len(listfiles) <= 0:
        print(f"Directory {userdir} is empty")
        sys.exit(120)
    return (listfiles)


def getext():
    """
    Get file extension from user

    """
    print("Input an extension type for all files to be renamed")
    userext = str(input("Extension type: "))
    return (userext)


def getnewext():
    """
    Get the new file extension
    """
    print("Input the new extension type:")
    newext = str(input("New Extension type: "))
    return (newext)


def do_work(listfiles, searchpattern, userdir, newext):
    """
    Function sets count=0, variable will be used to create new file name
    Gathers a list (listfiles) of files in currenct directory
    Loops over listfiles--> each item in list searched for file ext. user
    entered
    If ext is found, file is renamed using format:
    {count variable}.{user entered ext}
    """
    print('\n')
    count = 0
    # If all filenames in the list begin with a digit lamba would be useful
    # ---> see working_with-sort.py
    # orderlist = listfiles.sort(key=lambda f: int(''. join(filter(str. isdigit, f))))
    # listfiles.sort(key=lambda f: int(''. join(filter(str. isdigit, f))))
    for afile in listfiles:
        ftype = str(os.path.isfile(afile))
        if ftype == 'True':
            if afile.endswith(searchpattern):
                count += 1
                oldnametup = os.path.splitext(afile)
                oldname = oldnametup[0]
                # newname = str(count) + "." + searchpattern
                newname = oldname + "." + newext
                print(f"RENAME {afile} to {newname}")
                try:
                    os.rename(afile, newname)
                except PermissionError as eperm:
                    print(f"FAILED -- {eperm} for file {userdir}")
        else:
            print(f"SKIPPING directory: {afile}")

    if count == 0:
        print(f"\nNo files with ext. {searchpattern}"
              f" found in the directory {userdir}")
    else:
        print(f"\nTotal Files renamed: {count}")


if __name__ == '__main__':
    main()