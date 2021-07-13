#!/usr/bin/env python3

'''
Add global DOCKERCMD=docker ---> test if rc != 0
Change global DOCKERCMD=podman ---> test if rc != 0
---> Something went wrong

'''

import os
import subprocess
from sys import exit 
from listcontainers import get_dkrcontain
from listimages import get_dkrimages

def main():
    get_dkrimages
    get_dkrcontain
    myscript = os.__file__
    print("Entering Main for "+myscript)

# Do work
main()

if __name__ == "main":
    main()