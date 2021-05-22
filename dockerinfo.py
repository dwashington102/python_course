#!/usr/bin/env python3

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