#!/usr/bin/env python3

"""
This is how you print the function name when the function
is within another function
"""

import inspect 


def do_work():
    getfunc = inspect.currentframe()
    printfunc = getfunc.f_code.co_name
    print(f"{printfunc}()")


def main():
    do_work()


if __name__ == "__main__":
    main()
