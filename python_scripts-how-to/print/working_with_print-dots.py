#!/usr/bin/env python3

import shlex
import subprocess as sp
import re

def get_servers():
    server_list = ["8.8.8.8",
                   "8.8.4.4",
                   "1.1.1.1",
                   "1.1.1.1",
                   "1.1.1.1",
                   "1.1.1.1",
                   "1.1.1.1",
                   "1.1.1.1",
                   "1.1.1.1",
                   ]
    return server_list


def do_work(server_list):
    min_rtt = 9999
    count = 3
    delay = 1
    rate = 10
    dotcount = 0

    tot_servers = len(server_list)
    print(f'Sending nping test to {tot_servers} destinations.')
    for server in server_list:
        cmd = shlex.split(f"nping --icmp --count {count} --delay {delay} --rate {rate} {server}")
        results = sp.check_output(cmd)
        rawrtt = re.search('Avg rtt.*\n', results.decode('utf-8'))
        result = re.findall(r'\d+\.\d+', rawrtt[0])
        if len(result) > 0:
            avgrtt = float(result[0])
            if avgrtt < min_rtt:
                min_rtt = avgrtt
                fastest_server = server
                print(f"\nSASVPN with fastest avg. RTT {server}")
                print(f'\t-->Avg RTT: {avgrtt}')
                dotcount = 11
            else:
                if dotcount < 10:
                    print('.', end='', flush=True)
                    dotcount += 1
                else:
                    print('\n.')
                    dotcount = 0


    final_result = [fastest_server, min_rtt]
    return final_result


def main():
    print('\nStarting...')
    server_list = get_servers()
    do_work(server_list)
    print('\nEnding')


if __name__ == '__main__':
    main()
