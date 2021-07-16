#!/usr/bin/env python3

import subprocess
from listcontainers import get_containers

def docker_test():
    #capture_output=True : blocks stderr from being returned to console
    print("Testing docker command...")
    docker_cmd=subprocess.run(['which', 'docker'], capture_output=True)
    if docker_cmd.returncode==0:
        print('docker command found was successful')
        dockercmd='docker'
    else:
        print("Unable to find docker command")
        print("Testing podman command...")
        podman_cmd=subprocess.run(['which', 'podman'], stdout=subprocess.DEVNULL)
        if podman_cmd.returncode==0:
            print('podman command found was successful')
            dockercmd='podman'
        else:
            print("Unable to find docker command")
            print('Exiting...')
            exit
    print('DEBUG >>> dockercmd',dockercmd)
    get_containers(dockercmd)


def main():
    docker_test()

# Do work
main()

if __name__ == "main":
    main()


