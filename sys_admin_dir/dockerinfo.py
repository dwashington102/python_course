#!/usr/bin/env python3

'''
Add global DOCKERCMD=docker ---> test if rc != 0
Change global DOCKERCMD=podman ---> test if rc != 0
---> Something went wrong
'''

import os
import subprocess
from sys import exit 

# Custom modules/functions
#import set_docker_cmd 
#from listcontainers import get_containers
#from listimages import get_images

def main():
    print('\nEnter dockerinfo main')
    #set_docker_cmd
    #get_containers
    #get_images
    myscript = os.__file__
    print("Entering Main for "+myscript)

# Do work
main()

if __name__ == "main":
    main()
