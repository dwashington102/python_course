#!/usr/bin/env python3

import psutil
from time import sleep
from datetime import datetime


def main():
    psbatt = (psutil.sensors_battery())
    do_work(psbatt)


def check_ac(psbatt):
    psbatt = (psutil.sensors_battery())
    if psbatt.power_plugged:
        print("\nDevice is plugged into power supply...exit(0)")
        exit(0)


def do_work(psbatt):
    try:
        min = 1
        ipsbatt = int(psbatt.percent)
        while ipsbatt >= 5:
            check_ac(psbatt)
            fpsbatt = float(psbatt.percent)
            now = datetime.now()
            now_str = now.strftime("%Y%m%d-%H:%M:%S")
            print(f"{now_str} Minute {min} - Battery Percent {fpsbatt:.2f}%")
            psbatt = psutil.sensors_battery()
            min += 1
            sleep(5)
            ipsbatt = int(psbatt.percent)

        print(f"***WARNING BATTERY {ipsbatt}% IS LOW***")
        exit(0)
    except KeyboardInterrupt:
        print("\nUser Terminated...exit(0)")
        exit(0)


if __name__ == "__main__":
    main()
