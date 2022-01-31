#!/usr/bin/env python3
#

import subprocess
from sys import exit 
from time import sleep


def print_header():
    print_blank()
    print("=============================================")
    print("Container List.....")

def print_footer():
    print_blank()
    print("=============================================")

def print_blank():
    print("\n" * 2)

def get_containers(dockercmd):
    print_header()
    print("List of Running Docker Containers:")
    subprocess.run([dockercmd, 'container', 'ps'])
    get_exit_containers(dockercmd)
    print_footer()

def get_exit_containers(dockercmd):
    print('\nExited Containers')
    subprocess.run([dockercmd, 'container', 'ps', '-a'])


#def main():
#    print_header()
#    get_containers(dockercmd)
#    print_footer()

# Do work
#main()

#if __name__ == "main":
#    main()
