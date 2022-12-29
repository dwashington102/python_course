#!/usr/bin/env python3
"""
Script gathers these items:
> 5 most recent successful SSH connections with date & time
> List of IP addresses in sshd jail
> Top-5 same userid & hostname attempts
> Top-5 common login userids
"""

import os
import sys

try:
    import colorama
    import datetime
    # import re
    import subprocess
    from systemd import journal
    from datetime import datetime
except ModuleNotFoundError:
    print("Unable to load all modules")
    sys.exit(101)


def main():
    check_uid()
    try:
        set_header()
        set_timestamp()
        get_ssh_cons()
        # get_ip_fail2ban()
        get_banned_ips()
        set_header()
    except KeyboardInterrupt:
        print("\n\nUser Termination received")


def check_uid():
    """
    Function confirms the script is being ran as the root user
    """
    uid = os.getuid()
    if uid != 0:
        print("Script must be ran as root...exit(102)")
        sys.exit(102)


def set_header():
    print("*" * 50)


def set_timestamp():
    # Sets timestamp value to the current time
    timestamp = datetime.now()
    now_tstamp = datetime.strftime(timestamp, "%Y%m%d_%H%M")
    print(f"Current Time: {now_tstamp}\n")


def get_ssh_cons():
    # Function pulls "Accepted publickey" messages from journal
    searchAccepted = "Accepted publickey"
    red = colorama.Fore.RED
    green = colorama.Fore.GREEN
    normal = colorama.Fore.RESET
    ssh_cons = []

    readjournal = journal.Reader()
    readjournal.this_boot()
    readjournal.add_match(_SYSTEMD_UNIT="sshd.service")
    readjournal.seek_tail()
    readjournal.get_previous(200)

    count = 0
    for entry in readjournal:
        strEntry = str(entry)
        if searchAccepted in strEntry:
            count += 1
            if count > 5:
                break
            entryDate = entry['__REALTIME_TIMESTAMP']
            result = str(entryDate), entry['MESSAGE']
            ssh_cons.append(result)

    if ssh_cons:
        print(red + "Successful Connections:" + normal)
        for index, sshconnection in enumerate(ssh_cons, 1):
            print(f"{index}: {sshconnection}")
    else:
        print(green + "No successful connection found in journal")
        print(normal)


def get_ip_fail2ban():
    print("\nCurrent banip in sshd jail:")
    output = subprocess.Popen(['fail2ban-client', 'get', 'sshd', 'banned'],
                              stdout=subprocess.DEVNULL,
                              encoding="utf-8")
    print(f"DEBUG >>> output {output}")


def get_banned_ips():
    print("\n\nBanned IP Address List:")
    # Run the fail2ban-client command to get a list of banned IP addresses
    output = subprocess.run(['fail2ban-client', 'get', 'sshd', 'banned'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    lines = output.split('\n')

    # Find the line containing the list of banned IP addresses
    for line in lines:
        print(line)


if __name__ == "__main__":
    main()
