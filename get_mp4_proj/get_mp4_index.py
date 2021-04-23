#!/usr/bin/env python3

from datetime import datetime
import os
from os import path
from pathlib import Path
import shutil
import re
import subprocess
from time import sleep
import wget
import colorama

# Custom modules
import get_mp4_mkdir as get_mp4_mkdir

# Define CONSTANTS
now = datetime.now()
tStamp = now.strftime("%Y%m%d%H%M%S")
homeDir = Path.home()
curDir = Path.cwd()

# Set curDir to a string variable
s_curDir = str(curDir)

cyanColor = colorama.Fore.CYAN
redColor = colorama.Fore.RED
yellowColor = colorama.Fore.YELLOW                                                                    
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
            print('Delete files....')
            if curDir == homeDir:
                print(boldColor,redColor,'Script cannot be ran in $HOME',resetColor) 
                print('\n')
                exit 
            elif s_curDir ==  '/root':
                print(boldColor,redColor,'Script cannot be ran in /root',resetColor) 
                print('\n')
                exit 
            elif s_curDir ==  '/tmp':
                print(boldColor,redColor,'Script cannot be ran in /tmp',resetColor) 
                print('\n')
                exit 
            else:
                print(boldColor,redColor,'Create dir....')
                print('About to delete directories....',resetColor)
                sleep(10)
                for s_file in os.listdir(s_curDir):
                    pathDir = os.path.join(curDir, s_file) 
                    try:
                        shutil.rmtree(pathDir)
                    except OSError:
                        os.remove(pathDir)
                #get_mp4_mkdir.func_createDirs
        elif get_userChoice == 'n':
            print('Ok not removing existing files\n')
            if Path('index.html').is_file():
                indexRename = 'index.html_'+tStamp
                print('\nExisting index.html file being renamed index.html_'+tStamp)
                os.rename('index.html', indexRename)
                get_mp4_mkdir.func_createDirs
            else:
                print('\nNo existing index.html file found')

        elif get_userChoice == 'exit':
            print('Exit script')
            exit
        else:
            print(boldColor,redColor,'Invalid entry...try again',resetColor)
            get_userChoice = 'abc'



if __name__ == '__main__':
    main()
    print()
    print('end of program')