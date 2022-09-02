#!/usr/bin/env python3

import psutil
from time import sleep
from datetime import datetime

try:
    min = 1
    spsbatt = str(psutil.sensors_battery())
    sbatt = str(psutil.sensors_battery())
    psbatt = (psutil.sensors_battery())
    if spsbatt.isnumeric():
        ipsbatt = int(psbatt.percent)
        fpsbatt = float(psbatt.percent)
    else:
        print('Device not connected to battery...exit(4)')
        exit(4)

    while ipsbatt >= 5:
        now = datetime.now()
        now_str = now.strftime("%Y%m%d-%H:%M:%S")
        print(f"{now_str} Minute {min} - Battery Percent {fpsbatt:.2f}%")
        psbatt = psutil.sensors_battery()
        ipsbatt = int(psbatt.percent)
        fpsbatt = float(psbatt.percent)
        min += 1
        sleep(60)

    print(f"***WARNING BATTERY {ipsbatt}% IS LOW***")
    exit(0)
except KeyboardInterrupt:
    print("\nUser Terminated...exit(0)")
    exit(0)
