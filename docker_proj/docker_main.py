#!/usr/bin/env python3

# Script gathers a list of docker/podman images and containers

import subprocess


# Calling functions for other py scripts
from docker_listcontainers import get_containers
from docker_listimages import get_images


def docker_test():
    #capture_output=True : blocks stderr from being returned to console
    print("\nTesting docker command...")
    docker_cmd=subprocess.run(['command', '-v', 'docker'], capture_output=True)
    if docker_cmd.returncode==0:
        print('docker command found was successful')
        dockercmd='docker'
    else:
        print("Unable to find docker command")
        print("\nTesting podman command...")
        podman_cmd=subprocess.run(['command', '-v', 'podman'], capture_output=True)
        if podman_cmd.returncode==0:
            print('podman command found was successful')
            dockercmd='podman'
        else:
            print("Unable to find docker command")
            print('Exiting...')
            exit
    get_containers(dockercmd)
    get_images(dockercmd)


def main():
    docker_test()

# Do work
main()

if __name__ == "main":
    main()
