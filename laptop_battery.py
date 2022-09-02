#!/usr/bin/env python3

import psutil
from time import sleep
from datetime import datetime

try:
    min = 1
    psbatt = psutil.sensors_battery()
    ipsbatt = int(psbatt.percent)
    fpsbatt = float(psbatt.percent)

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
