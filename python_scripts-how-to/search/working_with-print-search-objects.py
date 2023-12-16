#!/usr/bin/env python3

import os
import re
import shlex
import subprocess as sp
import sys

ss = '/usr/sbin/ss'
ns = '/usr/bin/netstat'

if os.path.isfile(ss):
    oscmd = ss
elif os.path.isfile(ns):
    oscmd = ns
else:
    print('ss and netstat commands NOT FOUND')
    sys.exit(1)

netcmd = shlex.split(oscmd + ' -tpln')
rawresults = sp.check_output(netcmd)  # type bytes
results = rawresults.decode('utf-8')  # type string

# Search the string type returned from the subprocess check_output
found = re.search('.*cups.*', results)   # type Search object
print(found.group(0))


# print only the port number
# output of netcmd example
# LISTEN 0    128  0.0.0.0:50000    0.0.0.0:*  users:(("db2sysc",pid=123,id=6))
# Use this to capture only the port '50000' 

results = found.group(0)
portnum = results.split(':')[1].split()[0]
print(f'cups port number: {portnum}')

