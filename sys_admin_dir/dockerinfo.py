#!/usr/bin/env python3

'''
Add global DOCKERCMD=docker ---> test if rc != 0
Change global DOCKERCMD=podman ---> test if rc != 0
---> Something went wrong

'''

import os
import subprocess
from sys import exit 
from listcontainers import get_containers
from listimages import get_images

def main():
    get_containers
    get_images
    myscript = os.__file__
    print("Entering Main for "+myscript)

# Do work
main()

if __name__ == "main":
    main()