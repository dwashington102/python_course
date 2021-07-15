#!/usr/bin/env python3
#

import subprocess
from sys import exit 

def print_header():
    print_blank()
    print("=============================================")
    print("Begin Here.....")

def print_footer():
    print_blank()
    print("End Here.....")
    print("=============================================")

def print_blank():
    print("\n" * 2)

def get_containers():
    print("List of Running Docker Containers:")
    subprocess.check_call(['podman', 'ps'])

def main():
    print_header()
    get_containers()
    print_footer()

# Do work
main()

if __name__ == "main":
    main()
