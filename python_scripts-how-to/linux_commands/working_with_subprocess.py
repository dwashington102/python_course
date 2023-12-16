#!/usr/bin/env python3
"""
View pydoc for subprocess
$ pydoc subprocess

"""

import subprocess


# Pass in commands as an array
print("The ls command dumps all to terminal")
subprocess.run(["ls", "-ltr"])

# Redirect output to /dev/null
gsrc = subprocess.Popen(["gsettings", "list-schemas"],
                       stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL)


# Getting return code of a command
rc = gsrc.wait()
print(f"\nReturn code of {gsrc} is {rc}")
