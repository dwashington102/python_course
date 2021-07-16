#!/usr/bin/env python3

import subprocess

# Calling functions for other Python scripts
from logfile_tstamp import get_timestamp

def funcget_sysd():
    get_sysd=subprocess.run(['systemctl'], capture_output=True)
    if get_sysd.returncode==0:
        print('Server is running sysd')
    else:
        print('Server is running initd')
    

def main():
    logTime=get_timestamp()
    print('Time Now: ',logTime)
    funcget_sysd()



main()

if __name__ == "main":
    main()


