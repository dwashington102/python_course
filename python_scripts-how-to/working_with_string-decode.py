#!/usr/bin/env python3

import subprocess

try:
    currentbg = subprocess.check_output('gsettings get org.gnome.desktop.background picture-uri', shell=True)
    print(f"Before decode:\n{currentbg}")
    print(f"After decode:\n{str(currentbg.decode('utf-8'))}")
except:
    raise
