#!/usr/bin/env python3

try:
    import psutil
    from time import sleep
    from datetime import datetime
    import subprocess
except ImportError as e:
    print(f"\n{e}...exit(4)")
    exit(4)


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
        try:
            ipsbatt = int(psbatt.percent)
        except AttributeError:
            print("Device does not have a battery...exit(0)")
            exit(0)
        if type(ipsbatt) == "None":
            print("Type is NONE")
            exit(0)

        while ipsbatt >= 5:
            tunedadm = subprocess.Popen(['tuned-adm', 'active'],
                                        stdout=subprocess.PIPE)
            awk = subprocess.Popen(['awk', "{print $4}"],
                                   stdin=tunedadm.stdout,
                                   stdout=subprocess.PIPE)
            tunedadm.stdout.close()
            tuneprofile = awk.communicate()[0]

            cpupct = float(psutil.cpu_percent())
            check_ac(psbatt)
            fpsbatt = float(psbatt.percent)
            now = datetime.now()
            now_str = now.strftime("%Y%m%d-%H:%M:%S")
            print(f"{now_str} Minute {min} - Battery Percent {fpsbatt:.2f}% - "
                  f"CPU Percent {cpupct:.2f}% - "
                  f"Profile: {str(tuneprofile.decode('utf-8'))}")
            psbatt = psutil.sensors_battery()
            min += 1
            sleep(60)
            ipsbatt = int(psbatt.percent)

        print(f"***WARNING BATTERY {ipsbatt}% IS LOW***")
        exit(0)
    except KeyboardInterrupt:
        print("\nUser Terminated...exit(0)")
        exit(0)


if __name__ == "__main__":
    main()
