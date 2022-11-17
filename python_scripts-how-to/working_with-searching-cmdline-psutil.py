#!/usr/bin/env python3
"""
Function gathers a list of running processes on the server
- extracts all "python3" processes
- checks if the "python3" processes are running a specific script
"""
import psutil

# getpid = psutil.Process class

searchcmd = "python3"
searchpy = "/opt/ibm/registration/registration.py"

for get_pypid in psutil.process_iter():
    if searchcmd in get_pypid.cmdline():
        for line in get_pypid.cmdline():
            if searchpy in line:
                print(f"{line}: TRUE")
