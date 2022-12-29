#!/usr/bin/env python3

import sys

try:
    import colorama
    import datetime
    import re
    import subprocess
    from systemd import journal
    from datetime import datetime
    from time import sleep
except ModuleNotFoundError:
    print("Unable to load all modules")
    sys.exit(101)


def main():
    try:
        set_header()
        set_timestamp()
        get_ssh_cons()
        # get_ip_fail2ban()
        get_banned_ips()
        set_header()
    except KeyboardInterrupt:
        print("\n\nUser Termination received")


def set_header():
    print("*" * 50)


def set_timestamp():
    # Sets timestamp value to the current time
    timestamp = datetime.now()
    now_tstamp = datetime.strftime(timestamp, "%Y%m%d_%H%M")
    print(now_tstamp)


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
    readjournal.get_previous(10)

    for entry in readjournal:
        strEntry = str(entry)
        if searchAccepted in strEntry:
            ssh_cons.append(entry['MESSAGE'])

    if ssh_cons:
        print(red + "Successful Connections:" + normal)
        for index, sshconnection in enumerate(ssh_cons, 1):
            entryDate = entry['__REALTIME_TIMESTAMP']
            print(f"{index} {entryDate} {sshconnection}")
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