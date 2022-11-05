#!/usr/bin/env python3


import os
from datetime import datetime
import subprocess


now = datetime.now()
nowstr = now.strftime("%Y%m%d_%H%M%S")

dirpath = "/tmp/"
logfile = nowstr

logfile = dirpath + logfile + ".log"

print(f"Filename: {logfile}")

os.mknod(logfile, mode=0o755)
