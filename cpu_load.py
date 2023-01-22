#!/usr/bin/env python3
"""
Script gathers the 1,5,15 minute load avg of the CPUs


Exit Codes:


Output of script:
Total Number of CPUs: 20

CPU 1-min load: 1.52490234375
CPU 5-min load: 1.484375
CPU 15-min load: 1.181640625

CPU 1min AVG: 9.53%
CPU 5min AVG: 9.28%
CPU 15min AVG: 7.39%
"""
import os


cputotal = int(os.cpu_count())
load1, load5, load15 = os.getloadavg()

print(f"Total Number of CPUs: {cputotal}")

print(f"\nCPU 1-min load: {load1}")
print(f"CPU 5-min load: {load5}")
print(f"CPU 15-min load: {load15}")

cpu_1min_pct = (load1 / 16) * 100
cpu_5min_pct = (load5 / 16) * 100
cpu_15min_pct = (load15 / 16) * 100

print(f"\nCPU 1min AVG: {cpu_1min_pct:.2f}%")
print(f"CPU 5min AVG: {cpu_5min_pct:.2f}%")
print(f"CPU 15min AVG: {cpu_15min_pct:.2f}%")
