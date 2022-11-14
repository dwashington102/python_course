#!/usr/bin/env python3

"""
Script gather the Operating System Version and python version

Output:
$ ./working_with-printing-dictionary-key-values.py
python version 3.06 is less than 3.10
('Red Hat Enterprise Linux', '8.6', 'Ootps')

"""

import platform as p


try:
    def main():
        pyver = get_python_version()
        do_work(pyver)
except KeyboardInterrupt:
    print("user exit received...exit(0)")
    exit(0)


def get_python_version():
    """
    Function gathers the current version of python.
    If the python version minor value includes only 1 digit, the minor
    version variable adds a 0 before the value.  This is to ensure that
    python 3.6 is not greater than python 3.10
    """
    rawver = p.python_version()
    verlist = rawver.split(".")
    pyvermajor = verlist[0]
    pyverminor = verlist[1]

    if len(pyverminor) < 2:
        pyverminor = "0" + pyverminor

    pyver = pyvermajor + "." + pyverminor
    return pyver


def do_work(pyver):
    if float(pyver) < 3.10:
        print(f"python version {pyver} is less than 3.10")
        osversion = p.linux_distribution()
    else:
        """
        How to print keys:values of the dictionary
        (ins)>>> abc = platform.freedesktop_os_release()
        (ins)>>> print(abc)

        Output showing dictionay key and value:
        {'NAME': 'Fedora Linux', 'ID': 'fedora',
        'PRETTY_NAME': 'Fedora Linux 36 (Cinnamon)',
        'VERSION': '36 (Cinnamon)', 'VERSION_ID': '36'
        """
        print(f"python version {pyver} at or above 3.10")
        hostos = p.freedesktop_os_release()
        osname = hostos['NAME']
        osver = hostos['VERSION_ID']
        osversion = osname + " " + osver

    print(f"{osversion}")


if __name__ == "__main__":
    main()
