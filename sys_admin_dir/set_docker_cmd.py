#!/usr/bin/env python3


'''
Tue 13 Jul 2021 08:39:09 PM CDT
Purpose: Test if the server is using docker or podman to manage containers
'''

import os
import subprocess
from sys import exit
from time import sleep


def docker_test():
    get_dockerCmd = "docker"
    print('DEBUG >>> get_dockerCmd')
    #get_dockerCmd = subprocess.call(get_dockerCmd, shell=True)
    return_value = os.system('docker &> /dev/null')
    sleep(10)
    print("\nDocker Test Returns: ", get_dockerCmd)
    print('returned value:  ', return_value)
    

def podman_test():
    get_podmanCmd = "podman"
    return_value = subprocess.call(get_podmanCmd, shell=True)
    print("\nPodman Test Returns: ", return_value)
    print('returned value:  ', return_value)

def main():
    print('DEBUG >>> in main')
    docker_test()
    podman_test()

# Do work
main()

if __name__ == "main":
    main()





