#!/usr/bin/env python3


import platform as p


try:
    def main():
        """
        Script gather the Operating System Version
        """
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
        # print(f"python version {pyver} is less than 3.10")
        hostos = p.linux_distribution()
        osname = hostos[0]
        osver = hostos[1]

    else:
        # print(f"python version {pyver} at or above 3.10")
        hostos = p.freedesktop_os_release()
        osname = hostos['NAME']
        osver = hostos['VERSION_ID']

    osversion = osname + " " + osver
    print(f"{osversion}")


if __name__ == "__main__":
    main()
