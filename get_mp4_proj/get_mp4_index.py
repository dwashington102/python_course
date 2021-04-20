#!/usr/bin/env python3

from datetime import datetime
import os
from os import path
from pathlib import Path
import re
import subprocess
from time import sleep
import wget
import colorama

# Define CONSTANTS
tStamp = datetime.now()
homeDir = Path.home()
curDir = Path.cwd()
cyanColor = colorama.Fore.CYAN
redColor = colorama.Fore.RED
yellowColor = colorama.Fore.YELLOW                                                                    
# resetColor = colorama.Fore.RESET
boldColor = colorama.Style.BRIGHT
resetColor = colorama.Style.RESET_ALL


def main():
    func_getUserUrl()

def func_getUserUrl():
    print('\n')
    print(boldColor,yellowColor+"WARNING "*4)
    print("This script will remove ALL files in the current directory --- ",cyanColor,curDir)
    print("\nDo you want to remove ALL files:",resetColor)

    get_userChoice = 'abc'
    while get_userChoice == 'abc':
        print('Type "yes" to DELETE ALL FILES IN CURRENT DIRECTORY before adding directories created by this script')
        print('Type "n" to leave existing files and directories created by this script')
        print('Type "exit" to exit the script')
        print('\n')
        get_userChoice=str(input('>>> '))
        if get_userChoice == 'yes':
            print('Delete files')
            print('DEBUG curDir',curDir)
            print('DEBUG homeDir',homeDir)
            if curDir == homeDir:
                print(boldColor,redColor,'Script cannot be ran in $HOME',resetColor) 
                print('\n')
                exit 
            elif curDir ==  '/root':
                print(boldColor,redColor,'Script cannot be ran in /root',resetColor) 
                print('\n')
                exit 
            elif curDir ==  '/tmp':
                print(boldColor,redColor,'Script cannot be ran in /tmp',resetColor) 
                print('\n')
                exit 
            else:
                print(boldColor,redColor,'About to delete directories....',resetColor)
                sleep(10)
        elif get_userChoice == 'n':
            print('DO NOT DELETE FILES')
        elif get_userChoice == 'exit':
            print('Exit script')
            exit
        else:
            print(boldColor,redColor,'Invalid entry...try again',resetColor)
            get_userChoice = 'abc'

    


# Text color functions
def print_yellow():
    print(ycolor)

def reset_tex():
    print(resetcolor)


if __name__ == '__main__':
    main()
    print()
    print('end of program')