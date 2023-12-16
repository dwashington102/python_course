#!/usr/bin/env python3
'''
Script demonstrates how to loop through a file,
add unique items in the file to a list, and then
print the list in order to show the unique values
from the file.

contents of the /os.types file:
Linux Fedora 39 (6.5.6-300.fc39.x86_64)
Linux Red Hat Enterprise 8.8 (4.18.0-477.27.1.el8_8.x86_64)
Linux Red Hat Enterprise 8.8 (4.18.0-477.27.1.el8_8.x86_64)
Linux Red Hat Enterprise 8.8 (4.18.0-477.27.1.el8_)
'''

from sys import exit
from time import sleep


def main():
    try:
        duplist = []
        kerneltxt = "/tmp/os.types"

        with open(kerneltxt, "r") as fd:
            for line in fd:
                print(f"{type(line)}")

                if line not in duplist:
                    duplist.append(line)
                else:
                    pass

        print(f"Total: {len(duplist)}")
        sortedk = sorted(duplist)
        loopcount = 0
        for kernel in sortedk:
            loopcount += 1
            print(f"({loopcount}) {kernel.strip()}")
            sleep(2)
    except KeyboardInterrupt:
        print("User interrupt received")
        exit(0)


if __name__ == '__main__':
    main()
