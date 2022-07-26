#!/usr/bin/env python3

'''
Exit Codes
1 - Server is running initd
2 - Unable to start ssh

'''

import os
import subprocess
import sys
from time import sleep

# Calling functions for other Python scripts
from clear_screen import clear
from logfile_tstamp import get_timestamp
from create_logfile import createlog


def func_confirm_daemon():
    get_sysd = str(subprocess.check_output(['ps', '-q', '1', '-o', 'comm='])
                   .decode(sys.stdout.encoding))
    if get_sysd.startswith('system'):
        print('Server is running systemd')
    else:
        print('Server is running initd')
        sys.exit(1)


def func_get_status_sysd():
    get_stat = os.system('systemctl status sshd |'
                        + 'grep "Active:.*active.*running.*since" > /dev/null')
    if get_stat != 0:
        print('\nNetworkManager is down, restarting...')
        start_stat = os.system('systemctl start ssh &> /dev/null')
        if start_stat != 0:
            print('Unable to start service....')
            sys.exit(2)
    else:
        print('\nNetworkManager is currently running')


def main():
    clear()
    func_confirm_daemon()
    try:
        createlog()
    except OSError as e:
        print('\nERROR....{}'.format(e))
        sys.exit(3)
    func_get_status_sysd()


main()

if __name__ == "main":
    main()
