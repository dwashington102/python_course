#!/usr/bin/env python3

import glob
import os
import re

from datetime import datetime


def check_cert_expire():
    # global FLAGGED
    search_expire = 'Current Date.*2024'
    # search_expire = 'Client Certificate expires in.*day.*refreshing it now'
    log_directory = '/var/opt/BESClient/__BESData/__Global/Logs'
    if os.path.isdir(log_directory):
        besclient_logs = glob.glob(os.path.join(log_directory, '*.log'))

    if besclient_logs:
        recent_log = max(besclient_logs, key=os.path.getctime)
        today = datetime.now().date()

        recent_log_ctime = os.path.getctime(recent_log)
        convert_recent_ctime = datetime.fromtimestamp(recent_log_ctime).date()

        # print(recent_log_ctime)
        # print(convert_recent_ctime)

        if convert_recent_ctime == today:
        # print(f'{recent_log} gen. today')
            with open(recent_log, 'r') as beslog:
                for line in beslog:
                    if re.search(search_expire, line):
                        print('search FOUND')
                        # FLAGGED += 1
                        break
        else:
            print('DATE NOT TODAY')
    else:
        print('BES Client log NOT FOUND')


def main():
    check_cert_expire()


if __name__ == '__main__':
    main()

