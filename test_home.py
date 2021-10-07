#!/usr/bin/env python3
# Just a test

import os
from pathlib import Path

homeDir = Path.home()
curDir = Path.cwd()

print('DEBUG homeDir:', homeDir)
print('DEBUG curDir:', curDir)

if curDir == homeDir:
    print('True')
else:
    print('False')
