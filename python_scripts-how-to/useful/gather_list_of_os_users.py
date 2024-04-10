#!/usr/bin/env python3
'''
Use the pwd module to gather a list of OS userids 
'''

import pwd


for osuser in pwd.getpwall():
    if osuser.pw_uid >= 1000 and osuser.pw_uid <= 59999:
        print(f"username: {osuser.pw_name}")
        print(f"\tUID: {osuser.pw_uid}")
        print(f"\tGID: {osuser.pw_gid}")
        print(f"\tComment: {osuser.pw_gecos}")
        print(f"\tHome: {osuser.pw_dir}")
        print(f"\tShell: {osuser.pw_shell}")
