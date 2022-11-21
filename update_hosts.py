#!/usr/bin/env python3
"""
Script pulls down the latest hosts.txt file from
http://winhelp2002.mvps.org/hosts.txt, replacing /etc/hosts
with the hosts.txt file, and appends manual entries that
exists in /root/.etchosts file

EXIT Codes:
Exit Code - Function: Msg
-------------------------
99  - Unable to download hosts.txt
101 - enable_logging: Permission denied when creating logfile
102 - attempted to run script as non-root user 


"""

import logging
import os
import selinux
import shutil
import subprocess
import sys


def main():
    enable_loggging()
    logging.info("main()")
    get_hosts()
    move_hosts()
    check_se()
    logging.info("main completed")


def enable_loggging():
    try:
        logging.basicConfig(filename="/root/cronlogs/update_hosts-timestamp.log",
                            format='%(asctime)s %(levelname)-5s %(message)s',
                            filemode="w",
                            level=logging.DEBUG,
                            datefmt='%Y-%m-%d %H:%M:%S')
        logging.info("Logging enabled")
    except PermissionError as perr:
        print("Permission denied creating logfile")
        sys.exit(101)


def check_uid():
    logging.info("check_uid()")
    uid = os.getuid()
    if uid != 0:
        logging.error("Script must be ran as root...exit(102)")
        sys.exit(102)

def get_hosts():
    logging.info("get_hosts()")
    os.chdir("/tmp")
    subprocess.run(["wget", "http://winhelp2002.mvps.org/hosts.txt"],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL)
    if not os.path.isfile("/tmp/hosts.txt"):
        logging.error(f"File download failed")
        sys.exit(99)
    else:
        logging.info(f"File download complete")


def move_hosts():
    logging.info("move_hosts()")
    os.remove("/etc/hosts")
    shutil.move("hosts.txt", "/etc/hosts")
    roothosts = open("/root/.etchosts", "r")
    with open("/etc/hosts", "a") as etchosts:
        etchosts.write(roothosts.read())
    roothosts.close()


def check_se():
    logging.info("check_se()")
    etchosts = "/etc/hosts"
    if selinux.is_selinux_enabled:
        logging.info(f"SE Linux Enabled")
        # Set command and arguments for semanage command
        se_cmd = "/usr/sbin/semanage"
        se_arg1 = "fcontext"
        se_arg2 = "-a"
        se_arg3 = "-t"
        se_arg4 = "etc_t" 
        se_arg5 = "-s system_u"

        # Set command and arguments for restorecon command
        re_cmd = "/usr/sbin/restorecon"
        re_arg1 = "-vF"

        etcbefore = subprocess.check_output(["ls", "-ltZ", etchosts])
        logging.info(etcbefore.decode("utf-8"))
        
        subprocess.Popen([se_cmd,
                                se_arg1,
                                se_arg2,
                                se_arg3,
                                se_arg4,
                                se_arg5,
                                etchosts],
                                stdout=subprocess.DEVNULL,
                                stderr=subprocess.DEVNULL)
       
        subprocess.Popen([re_cmd,
                               re_arg1,
                               etchosts],
                               stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL)

        etcafter = subprocess.check_output(["ls", "-ltZ", etchosts])
        logging.info(etcafter.decode("utf-8"))
        

if __name__ == "__main__":
    main()
