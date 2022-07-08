#!/usr/bin/env python3

import os
import argparse

parser = argparse.ArgumentParser(description='Simple script to demonstrate using argparse library.  The script allows the user to pass an argument as a directory name.  The script will then attempt to cd to the "/tmp/{arg}" directory')
parser.add_argument('new_dir', type=str, help='New Directory')
args = parser.parse_args()

previous_dir = os.getcwd()
print("Current Directory: {}\n".format(previous_dir))
print("New Directory: {}\n".format(args.new_dir))

newDir = "/tmp/" + args.new_dir
print("Base Directory: {}\n".format(newDir))

try:
    os.chdir(newDir)
    print("New Directory: {}\n".format(newDir))
    os.system('ls -l')
except:
    print("Unable to cd to {}\n".format(newDir))
