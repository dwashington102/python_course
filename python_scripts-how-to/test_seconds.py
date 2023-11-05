#!/usr/bin/env python3

import time

start_time = time.time()
expired_time = 1571
get_minutes = 1571 / 60

print(get_minutes)
fmt_minutes = int(f"{get_minutes:.0f}")
print(fmt_minutes)

get_seconds = expired_time - (60 * fmt_minutes)

print(f"Minutes: {fmt_minutes} Seconds:{get_seconds}")

print(f"DEBUG >>> type {type(start_time)}")
