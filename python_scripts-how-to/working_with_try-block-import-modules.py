#!/usr/bin/env python3

try:
    import ldap
    import os
    import subprocess
except ImportError as moderr:
    print(f"{moderr}...exit(1)")
    exit(1)
