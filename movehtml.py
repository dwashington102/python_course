# Import modulew
from os import walk
import os
from pathlib import Path
import shutil
import time

# Define GLOBAL CONSTANTS
HOMEDIR = str(Path.home())
IMG_DIR= HOMEDIR + '/Temp/images/'
HTML_DIR='/home/devdavid/Temp/images/html/'

def main():
    list_files(IMG_DIR)


def list_files(directory):
    print('DEBUG IMG_DIR >>> ', IMG_DIR)
    for (dirpath, dirname, filenames) in walk(directory):
        for myfile in filenames:
            if myfile.endswith('.' + 'jpg'):
                pass
            elif myfile.endswith('.' + 'gif'):
                pass
            elif myfile.endswith('.' + 'mp4'):
                pass
            elif myfile.endswith('.' + 'webm'):
                pass
            elif myfile.endswith('.' + 'png'):
                pass
            else:
                print('Moving ', myfile, '.....')
                #time.sleep(3)
                try:
                    move_html(myfile)
                except:
                    print('Moving for ', myfile, 'failed.')

               

def move_html(myfile):
    print('Entered move_html()')
    shutil.move(myfile, HTML_DIR)

main()
