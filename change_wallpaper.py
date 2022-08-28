#!/usr/bin/env python3
# Script changes the Linux Desktop Background using the gsettings command:

from gi.repository import Gio
import os
import random
import subprocess
import time


# Define GLOBAL CONSTANTS
# Location of directory where the pictures are stored
BACKGROUNDS = '/usr/share/backgrounds/various'

"""
DEBUG Format --- Only use when troubleshooting a problem
    debugtxt = "DEBUG >>>> entered function {} variable {}"
    print(debugtxt.format(cinnamon_set_wallpaper.__name__, wallpaper))
    exit(1)
"""


def main():
    get_current_bg()
    check_mypath()
    get_wallpaper()


def check_mypath():
    """ Function will confirm if directory defined by BACKGROUNDS exists.
    If not the program exits
    """
    test_dir = (os.path.isdir(BACKGROUNDS))
    if test_dir is True:
        time.sleep(3)
    else:
        print('PATH:', BACKGROUNDS, " does not exists")
        print('Exiting...')
        exit(1)


def get_wallpaper():
    """ Function builds a list of backgrounds stored in
    directory assigned to BACKGROUNDS variable and then
    selects a random item from the list
    """
    wallpaper_lst = []

    for (dirpath, dirname, filenames) in os.walk(BACKGROUNDS):
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
    get_wm(wallpaper)


def set_wallpaper(wallpaper):
    """ For GNOME WM function uses gi module to set schema
    org.gnome.desktop.background
    """
    settings = Gio.Settings.new("org.gnome.desktop.background")
    settings.set_string("picture-uri", "file://" + BACKGROUNDS + '/' + wallpaper)
    settings.apply()
    print(f"Updated Background image: 'file:///{BACKGROUNDS}/{wallpaper}'")


def cinnamon_set_wallpaper(wallpaper):
    """ For Cinnamon WM function uses gi module to set schema
    org.cinnamon.desktop.background
    """
    beforebg = subprocess.check_output('gsettings get org.cinnamon.desktop.background picture-uri', shell=True)
    # Clear var beforebg from memory
    del beforebg

    settings = Gio.Settings.new("org.cinnamon.desktop.background")
    settings.set_string("picture-uri",
                        "file://" + BACKGROUNDS + '/' + wallpaper)
    settings.apply()
    print(f"\nUpdated Background image: {BACKGROUNDS}/{wallpaper}")


def get_wm(wallpaper):
    # Confirm if the WM is GNOME or Cinnamon
    try:
        subprocess.check_output('pgrep gdm', shell=True)
        set_wallpaper(wallpaper)
    except subprocess.CalledProcessError:
        cinnamon_set_wallpaper(wallpaper)


def get_current_bg():
    beforebg = subprocess.check_output('gsettings get org.gnome.desktop.background picture-uri', shell=True)
    print(f"Current background image: {str(beforebg.decode('utf-8'))}")
    # Clear var beforebg from memory
    del beforebg


if __name__ == '__main__':
    main()
