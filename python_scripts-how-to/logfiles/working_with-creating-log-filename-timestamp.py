#!/usr/bin/env python3


import logging
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
logging.basicConfig(filename=logfile, filemode="w", level=logging.DEBUG)

logging.info("DEBUG LEVEL: DEBUG and above with WRITE action")
logging.debug("debug messages")
logging.info("info message")
logging.warning("warn message")
logging.error("error message")
logging.critical("critical")

