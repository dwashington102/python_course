import os
import sys


def clear():
    hostos = sys.platform
    try:
        if hostos == 'win':
            os.system('clear')
        elif hostos == 'cygwin':
            os.system('clear')
        else:
            os.system('clear')

    except Exception as e:
        print('\nDEBUG ENTER EXCEPTION\n')
        print('\nFailed to clear the screen error: ', e)


def main():
    clear()


if __name__ == '__main__':
    main()
