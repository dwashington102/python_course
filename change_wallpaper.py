#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
import os
import sys
import random
import time
from os import path


# Script changes the Linux Desktop Background using the gsettings command:
# Define GLOBAL CONSTANTS
# Location of directory where the pictures are stored
BACKGROUNDS = '/usr/share/backgrounds/various'


def main():
    get_current_bg()
    check_mypath()
    get_wallpaper()
    get_updated_bg()


def check_mypath():
    ''' Function will confirm if directory defined by BACKGROUNDS exists.
    If not the program exits
    '''
    test_dir = (path.isdir(BACKGROUNDS))
    if test_dir is True:
        time.sleep(3)
    else:
        print('PATH:', BACKGROUNDS, " does not exists")
        print('Exiting...')
        exit(1)


def get_wallpaper():
    # Function builds a random list of backgrounds in BACKGROUNDS
    wallpaper_lst = []

    for (dirpath, dirname, filenames) in os.walk(BACKGROUNDS):
        for afile in filenames:
            wallpaper_lst.append(afile)

    mytest = len(wallpaper_lst)
    ''' Decrease size of mytest by 1 to account for wallpaper_lst[]
    starting at 0 rather than 1
    '''
    mytest = mytest - 1
    my_rand = random.randint(0, mytest)
    # Sets the wallpaper to a random item from the wallpaper_lst
    wallpaper = wallpaper_lst[my_rand]
    get_wm(wallpaper)


def set_wallpaper(wallpaper):
    # For GNOME WM function uses gi module to set schema org.gnome.desktop.background
    settings = Gio.Settings.new("org.gnome.desktop.background")
    settings.set_string("picture-uri", "file://" + BACKGROUNDS + '/' + wallpaper)
    settings.apply()


def cinnamon_set_wallpaper(wallpaper):
    # For Cinnamon WM function uses gi module to set schema org.cinnamon.desktop.background
    settings = Gio.Settings.new("org.cinnamon.desktop.background")
    settings.set_string("picture-uri", "file://" + BACKGROUNDS + '/' + wallpaper)
    settings.apply()


def get_wm(wallpaper):
    # Confirm if the WM is GNOME or Cinnamon
    wm_type = os.system('gsettings get org.gnome.desktop.background picture-uri > /dev/null  2>&1')
    if wm_type != 0:
        cinnamon_set_wallpaper(wallpaper)
    else:
        set_wallpaper(wallpaper)


def get_current_bg():
    print('\n'+'Current background image:  ')
    os.system('gsettings get org.gnome.desktop.background picture-uri')


def get_updated_bg():
    print('\n'+'Updated background image:  ')
    os.system('gsettings get org.gnome.desktop.background picture-uri')


if __name__ == '__main__':
    main()
