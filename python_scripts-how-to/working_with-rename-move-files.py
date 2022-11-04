#!/usr/bin/env python3
"""
Script to move/rename files
"""

import shutil


try:
    shutil.move('/tmp/before.txt', '/tmp/after.txt')
except:
    raise
