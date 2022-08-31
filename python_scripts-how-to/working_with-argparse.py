#!/usr/bin/env python3


"""
Another useful example of argparse library can be found in the clone-ibmrepo.py script
"""

import os
import argparse


def main():
    do_work()


def do_work():
    parser = argparse.ArgumentParser(
        description='Simple script to demonstrate using argparse library'
        'The script allows the user to pass an argument as a directory name'
        'The script will then attempt to cd to the "/tmp/{arg}" directory'
    )
    parser.add_argument(
        "-d", dest="DIRECTORY", type=str, help="New Directory", required=True
    )
    args = parser.parse_args()

    previous_dir = os.getcwd()
    print(f"Current Directory: {previous_dir}\n")
    print(f"New Directory: {args.DIRECTORY}")

    newDir = "/tmp/" + args.DIRECTORY
    print(f"Base Directory: {newDir}")

    try:
        os.chdir(newDir)
        print(f"New Directory: {newDir}")
        os.system("ls -l")
    except:
        print(f"Unable to cd to {newDir}")


if __name__ == "__main__":
    main()
