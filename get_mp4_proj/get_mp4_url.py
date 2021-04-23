#!/usr/bin/env python3


# Import Python functions
import os
import wget

# Import Custom functions


# Define CONSTANTS


def main ():
    func_getUserUrl()

def func_getUserUrl ():
    get_userUrl=str(input('Input Remote URL: '))
    wget.download(get_userUrl, 'index.html', bar=None)
    if os.path.isfile('index.html'):
        print('\nDEBUG >>> index.html exists')
    else:
        print('\nDEBUG >>> index.html NOT FOUND')


if __name__ == '__main__':
    main()
    print('\nend of program')