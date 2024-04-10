#!/usr/bin/env python3
'''
Use the pwd module to gather a list of OS userids 
'''

import pwd


for osuser in pwd.getpwall():
    if osuser.pw_uid >= 1000 and osuser.pw_uid <= 59999:
        print(f"username: {osuser.pw_name}")
        print(f"Userid for {osuser.pw_name} is {osuser.pw_uid}")

