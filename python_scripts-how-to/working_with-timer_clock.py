#!/usr/bin/env python3
"""
Script is a simple timer
"""


from time import sleep


def main():
    secs = 0
    mins = 0
    hrs = 0 
    timer_seconds(hrs, mins, secs)


def timer_seconds(hrs, mins, secs):
    try:
        while secs <= 59:
            secstr = secs
            minstr = mins
            hrstr  = hrs
    
            # Pad single digits with "0" before printing
            if secs < 10:
                secstr = "0"+str(secs)
            if mins < 10:
                minstr = "0"+str(mins)
            if hrs < 10:
                hrstr = "0"+str(hrs)
    
            print(hrstr,":",minstr,":",secstr,"\r", end='',flush=True)
            secs += 1
            if secs == 60:
                secs = 0
                mins += 1
            if mins == 60:
                mins = 0
                hrs += 1
            if hrs == 24:
                hrs = 0
            sleep(1)
    except KeyboardInterrupt:
        print("User terminated")
        exit(0)


if __name__ == "__main__":
    main()
