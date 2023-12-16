#!/usr/bin/env python3

import subprocess

try:
    ret = subprocess.call(
        "ping -c1 8.8.8.8",
        shell=True,
        stdout=open("/dev/null", "w"),
        stderr=subprocess.STDOUT,
    )
    s_ret = str(ret)
    if s_ret == "0":
        print("Server is available")
    else:
        print("Sever is unavailable")
except:
    raise
