#!/usr/bin/env python3

import colorama
import psutil
from prettytable import PrettyTable
import sys


fgred = colorama.Fore.RED
resetcolor = colorama.Fore.RESET


def get_fs_info():
    t = PrettyTable(['Mount Point', 'Size(GB)', 'Used', 'Used%'])
    host_partitions = psutil.disk_partitions()
    for fs_part in host_partitions:
        total_disk = psutil.disk_usage(fs_part.mountpoint).total
        total_diskgb = total_disk / 1024**3
        used_disk = psutil.disk_usage(fs_part.mountpoint).used
        used_diskgb = used_disk / 1024**3
        pct_used = psutil.disk_usage(fs_part.mountpoint).percent

        total_diskgbfmt = f"{total_diskgb:.2f}"
        used_diskgbfmt = f"{used_diskgb:.2f}"
        pct_usedfmt = f"{pct_used:.2f}"

        if pct_used >= 40:
            pct_usedfmt = f"{fgred}{pct_used:.2f}{resetcolor}"
            t.add_row([fs_part.mountpoint.ljust(20), total_diskgbfmt.rjust(10), used_diskgbfmt.rjust(10), pct_usedfmt.rjust(10)])
        else:
            t.add_row([fs_part.mountpoint.ljust(20), total_diskgbfmt.rjust(10), used_diskgbfmt.rjust(10), pct_usedfmt.rjust(6)])

    print(t)


def main():
    # logfile = '/tmp/table.log'
    # logfile = open(logfile, 'a')
    # sys.stdout = logfile
    # logfile.truncate(0)

    get_fs_info()

if __name__ == '__main__':
    main()
