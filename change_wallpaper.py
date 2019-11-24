#!/usr/bin/env python3

import os
import sys
import random
import time
from os import path
import os.path

import gi
gi.require_version('Gtk', '3.0')
from  gi.repository import Gio, Gtk

#Define GLOBAL CONSTANTS
MYPATH='/usr/share/backgrounds/various'

#Define variables


def main():
    check_mypath()
    get_wallpaper()


# Function will confirm if directory defined by MYPATH exists.  If not the program exists
def check_mypath():                 
    test_dir = (path.isdir(MYPATH))
    if test_dir == True:   #Boolean check
        time.sleep(3)      #Sleep just for the heck of it
    else:
        print('PATH:', MYPATH, " does not exists")
        print('Exiting...')
        exit(1)

def get_wallpaper():    # Builds a list of files in MYPATH directory
    wallpaper_lst = []

    for (dirpath, dirname, filenames) in os.walk(MYPATH):
        for afile in filenames:
            wallpaper_lst.append(afile)

    mytest = len(wallpaper_lst)
    mytest = mytest - 1      # Decrease size of mytest by 1 to account for wallpaper_lst[] starting at 0 rather than 1
    #time.sleep(5)
    my_rand = random.randint(0, mytest) 
    wallpaper = wallpaper_lst[my_rand]    #Sets the wallpaper to a random item from the wallpaper_lst
    set_wallpaper(wallpaper)


# Uses gi module(s) to pass values to Gnome gsettings
def set_wallpaper(wallpaper):
    settings = Gio.Settings.new("org.gnome.desktop.background")
    settings.set_string("picture-uri", "file://" + MYPATH + '/' + wallpaper)
    settings.apply()


if __name__ == '__main__':
    main()

