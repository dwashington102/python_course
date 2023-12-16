#!/usr/bin/env python3


from os import path

with open("/tmp/dnf.conf", "w") as dnfconf:
    dnfconf.write('''[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
max_parallel_downloads=10
fastestmirror=True)
'''
)

if path.isfile("/tmp/dnf.conf"):
    print("Yep")


