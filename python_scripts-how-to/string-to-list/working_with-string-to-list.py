#!/usr/bin/env python3

import subprocess as sp
import shlex

domainlist = []

cmd = shlex.split('virsh list --name')
rawresults = sp.check_output(cmd)   # type=bytes
results = rawresults.decode('utf-8')  # type=str
domainlist = results.split('\n')     # type=list

for domain in domainlist:
    if domain:  # Used to avoid printing empty elements of list
        print(f'Domain Name: {domain}\n')
