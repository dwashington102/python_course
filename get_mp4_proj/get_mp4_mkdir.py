#!/usr/bin/env python3

from os import mkdir


#DEF CONSTANTS
tmpDir = './tmp'
mp4Dir = './mp4'
rawDir = './rawfiles'
logDir = './logdir'


def main ():
    print('DEBUG >>>> enter main mp4_mkdir\n')
    func_createDirs()


def func_createDirs ():
    try:
        mkdir(tmpDir)
    except:
        print('\nUnable to create ./tmp')
    
    try:
        mkdir(mp4Dir)
    except:
        print('\nUnable to create ./mp4')

    try:
        mkdir(rawDir)
    except:
        print('\nUnable to create ./rawfiles')
    
    try:
        mkdir(logDir)
    except:
        print('\nUnable to create ./logs')

if __name__ == '__main__':
    main()
    print()
    print('end of program')