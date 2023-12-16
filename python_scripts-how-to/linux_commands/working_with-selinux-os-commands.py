#!/usr/bin/env python3
"""
Script peforms the following steps 
 - Create a file
 - Check if SELinux is enabled
 - semanage and restorecon commands to update context type of new file

These steps are necessary IF the remote device does not have the python
selinux module installed.  Module is included with the python3-libselinux
package


Exit Codes:
Error Code - Function: Message
102     - check_uid: script must be ran as root user
"""


import os
import shutil
import subprocess as sp
from time import sleep


def main():
    print("starting main")
    check_uid()
    create_file()
    if os.path.isfile("/usr/sbin/selinuxenabled"):
        se_change()
    sleep(10)
    print("Final context")
    etc_after = sp.Popen(["ls", "-lZ", "/etc/TESTFILE"]) 


def check_uid():
    print("staring check_uid")
    """
    Function confirms the script is being ran as the root user
    """
    uid = os.getuid()
    if uid != 0:
        print("Script must be ran as root...exit(102)")
        exit(102)


def create_file():
        print("starting create_file")
        """
        Function creates /tmp/TESTFILE
        """
        print(f"    Before cd: {os.getcwd()}")
        os.chdir("/tmp")
        print(f"    AFTER cd: {os.getcwd()}")
        os.mknod("TESTFILE")
        tmp_context = sp.Popen(["ls", "-ltrZ", "/tmp/TESTFILE"]) 
        sleep(10)
        shutil.move("/tmp/TESTFILE", "/etc/TESTFILE")


def se_change():
    print("starting se_change")
    check_se = sp.run(["/usr/sbin/selinuxenabled"]).returncode
    # Set command and arguments for semanage command
    se_cmd = "/usr/sbin/semanage"
    se_args1 = "fcontext"
    se_args2 = "-a"
    se_args3 = "-t"
    se_args4 = "etc_t"
    se_args5 = "-s system_u"

    # Set command and arguments for restorecon command
    re_cmd = "/usr/sbin/restorecon"
    re_args1 = "-vF"

    if check_se == 0:
        print("selinux enabled")
        etc_before = sp.Popen(["ls", "-lZ", "/etc/TESTFILE"]) 
        sp.Popen([se_cmd,
                         se_args1,
                         se_args2,
                         se_args3,
                         se_args4,
                         se_args5,
                         "/etc/TESTFILE"],
                         stdout=sp.DEVNULL,
                         stderr=sp.DEVNULL)

        # log.info("DEBUG >>> calling restorecon")
        sp.Popen([re_cmd,
                         re_args1,
                         "/etc/TESTFILE"],
                         stdout=sp.DEVNULL,
                         stderr=sp.DEVNULL)


if __name__ == "__main__":
    main()