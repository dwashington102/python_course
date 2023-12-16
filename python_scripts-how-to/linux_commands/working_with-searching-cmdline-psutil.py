#!/usr/bin/env python3
"""
Function gathers a list of running processes on the server
- extracts all "python3" processes
- checks if the "python3" processes are running a specific script
"""
import psutil

# getpid = psutil.Process class

searchcmd = "/usr/bin/python3"
searchcmd_2 ="python3"
searchpy = "/usr/bin/guake"

for get_pypid in psutil.process_iter():
    if searchcmd in get_pypid.cmdline() or searchcmd_2 in get_pypid.cmdline():
        for line in get_pypid.cmdline():
            if searchpy in line:
                print(f"Current running python pid:{get_pypid.pid} --- {get_pypid.cmdline()}")
