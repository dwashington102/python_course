#!/usr/bin/env python3


'''
Tue 13 Jul 2021 08:39:09 PM CDT
Purpose: Test if the server is using docker or podman to manage containers
'''

import os
import subprocess
from sys import exit, stdout
from time import sleep


def docker_test():
    print('DEBUG >>> get_dockerCmd')
    #get_dockerCmd = subprocess.call(get_dockerCmd, shell=True)
    docker_cmd=subprocess.run(['docker', 'images'], stdout=subprocess.DEVNULL) 
    docker_rc=docker_cmd.returncode
    if docker_rc == 0:
        print('docker command was successful')
    elif docker_rc !=0:
        print("docker command failed to return imges.")
        print("Running podman command...")
        sleep 10
        podman_cmd=subprocess.run(['podman', 'images'], stdout=subprocess.DEVNULL)
        podman_rc=podman_cmd.returncode
        if podman_rc ==0:
            print('podman command was successful')
        else:
            print('podman command was succesful')
    else:
        print('Both commands failed to return available images')
        print('Exiting...')
        exit 3

    sleep(10)
    

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
