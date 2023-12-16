#!/usr/bin/env python3



try:
    with open("/tmp/bf_dnf.conf", "w") as output:
        output.write("""\
[main]
gpgcheck =1
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False
exclude=gstreamer-plugins-ugly transmission* wine*
max_parallel_downloads=10
fastermirror=True
""")
except:
    raise

print("build_dnf complete")
