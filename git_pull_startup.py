#!/usr/bin/env python3

from colorama import Fore, Back, Style
import datetime
import os

import logging

def main():
    
    timestamp = datetime.datetime.now()
    sTimestamp = datetime.datetime.strftime(timestamp, "%Y%m%d_%H%M")
    func_remove_old_dirs()

def print_space():
    print("\n")

def func_remove_old_dirs():
    getHomeDir = os.environ['HOME']
    gitdir = getHomeDir + "/GIT_REPO"
    pythonCourse = gitdir + "/python_course"
    dotfiles = gitdir + "/dotfiles"
    zshdir = gitdir + "/zshdir"
    dockerBuild = gitdir + "/dockerBuild"


if __name__ == '__main__':
    main()
