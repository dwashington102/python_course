#!/usr/bin/env python3
'''

'''
import subprocess
from sys import exit 


def print_header():
    print_blank()
    print("=============================================")
    print("Images.....")

def print_footer():
    print_blank()
    print("=============================================")

def print_blank():
    print("\n" * 2)

def get_images(dockercmd):
    print_header()
    print("List of Docker Images:")
    subprocess.run([dockercmd, 'images'])
    print_footer()


#def main():
#    print_header()
#    get_images()
#    print_footer()
#
## Do work
#main()
#
#if __name__ == "main":
#    main()
#