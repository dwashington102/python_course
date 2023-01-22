#!/usr/bin/env python3
"""
Script changes the Linux Desktop Background using the gsettings command:


Exit Codes:
101 - Failure to load python module
102 - gsettings_check(): No gsettings found
103 - set_backgroundsdir(): Unaccounted for XDG_CURRENT_DESKTOP
104 - check_mypath(): Unable to find dirbackgrounds directory
105 - get_wm(): Unaccounted for XDG_CURRENT_DESKTOP
106 - set_backgroundsdir(): XDG_CURRENT_DESKTOP is None
"""


try:
    from gi.repository import Gio
    import os
    import random
    import subprocess
    import time
    import sys
except ModuleNotFoundError as moderr:
    print(f"{moderr}...exit(101)")
    exit(101)


"""
DEBUG Format --- Only use when troubleshooting a problem
    debugtxt = "DEBUG >>>> entered function {} variable {}"
    print(debugtxt.format(cinnamon_set_wallpaper.__name__, wallpaper))
    exit(1)
"""


def main():
    """
    Script changes the Linux Desktop Background using the gsettings command:
    """
    try:
        dirbackgrounds = set_backgroundsdir()
        gsettings_check()
        get_current_bg()
        check_mypath(dirbackgrounds)
        get_wallpaper(dirbackgrounds)
    except KeyboardInterrupt:
        print("Received user termination request\n")
        exit(0)


def set_backgroundsdir():
    desktopenv = os.getenv("XDG_CURRENT_DESKTOP")
    if desktopenv is None:
        print("XDG_CURRENT_DESKTOP is None...exit(106)")
        sys.exit(106)

    if "gnome" in desktopenv.lower():
        dirbackgrounds = "/usr/share/backgrounds/various"
        print("Gnome")
    elif "cinnamon" in desktopenv.lower():
        dirbackgrounds = "/usr/share/backgrounds/various/images"
        print("Cinnamon")
    else:
        print(f"UNKNOWN: XDG_CURRENT_DESKTOP - {desktopenv}")
        sys.exit(103)
    return dirbackgrounds


def gsettings_check():
    gsrc = subprocess.Popen(["gsettings", "list-schemas"],
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL)
    rc = gsrc.wait()
    if rc != 0:
        print("No gsettings schemas found...exit(102)\n")
        sys.exit(102)


def check_mypath(dirbackgrounds):
    """ Function will confirm if directory defined by dirbackgrounds exists.
    If not the program exits
    """
    test_dir = (os.path.isdir(dirbackgrounds))
    if test_dir is True:
        time.sleep(3)
    else:
        print('PATH:', dirbackgrounds, " does not exists")
        print('Exiting...')
        exit(1)


def get_wallpaper(dirbackgrounds):
    """ Function builds a list of backgrounds stored in
    directory assigned to dirbackgrounds variable and then
    selects a random item from the list
    """
    wallpaper_lst = []

    for (dirpath, dirname, filenames) in os.walk(dirbackgrounds):
        for afile in filenames:
            wallpaper_lst.append(afile)

    mytest = len(wallpaper_lst)
    """ Decrease size of mytest by 1 to account for wallpaper_lst[]
    starting at 0 rather than 1
    """
    mytest = mytest - 1
    my_rand = random.randint(0, mytest)
    # Sets the wallpaper to a random item from the wallpaper_lst
    wallpaper = wallpaper_lst[my_rand]
    get_wm(wallpaper, dirbackgrounds)


def set_wallpaper(wallpaper, dirbackgrounds):
    """ For GNOME WM function uses gi module to set schema
    org.gnome.desktop.background
    """
    settings = Gio.Settings.new("org.gnome.desktop.background")
    settings.set_string("picture-uri", "file://" + dirbackgrounds + '/' + wallpaper)
    settings.apply()
    print(f"Updated Background image: 'file:///{dirbackgrounds}/{wallpaper}'")


def cinnamon_set_wallpaper(wallpaper, dirbackgrounds):
    """ For Cinnamon WM function uses gi module to set schema
    org.cinnamon.desktop.background
    """
    beforebg = subprocess.check_output('gsettings get org.cinnamon.desktop.background picture-uri', shell=True)
    # Clear var beforebg from memory
    del beforebg

    settings = Gio.Settings.new("org.cinnamon.desktop.background")
    settings.set_string("picture-uri",
                        "file://" + dirbackgrounds + '/' + wallpaper)
    settings.apply()
    print(f"\nUpdated Background image: {dirbackgrounds}/{wallpaper}")


def get_wm(wallpaper, dirbackgrounds):
    # Confirm if the WM is GNOME or Cinnamon
    desktopenv = os.getenv("XDG_CURRENT_DESKTOP")
    if "gnome" in desktopenv.lower():
        set_wallpaper(wallpaper, dirbackgrounds)
    elif "cinnamon" in desktopenv.lower():
        cinnamon_set_wallpaper(wallpaper, dirbackgrounds)
    else:
        print(f"UNKNOWN: XDG_CURRENT_DESKTOP - {desktopenv}")
        sys.exit(103)


def get_current_bg():
    beforebg = subprocess.check_output('gsettings get org.gnome.desktop.background picture-uri', shell=True)
    print(f"Current background image: {str(beforebg.decode('utf-8'))}")
    # Clear var beforebg from memory
    del beforebg


if __name__ == '__main__':
    main()
