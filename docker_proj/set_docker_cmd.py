#!/usr/bin/env python3

'''
Tue 13 Jul 2021 08:39:09 PM CDT
Purpose: Test if the server is using docker or podman to manage containers
'''

import os
import subprocess
from sys import exit, stdout
from time import sleep, time


def docker_test():
    #capture_output=True : blocks stderr from being returned to console
    print("Testing docker command...")
    docker_cmd=subprocess.run(['command', '-v' ,'docker'], capture_output=True)
    if docker_cmd.returncode==0:
        print('docker command found was successful')
        dockercmd='docker'
    else:
        print("Unable to find docker command")
        print("Testing podman command...")
        podman_cmd=subprocess.run(['command', '-v', 'podman'], stdout=subprocess.DEVNULL)
        if podman_cmd.returncode==0:
            print('podman command found was successful')
            dockercmd='podman'
        else:
            print("Unable to find docker command")
            print('Exiting...')
            exit
    print('DEBUG DOCKERCMD: ', dockercmd)
    

def main():
    docker_test()

# Do work
main()

if __name__ == "main":
    main()
