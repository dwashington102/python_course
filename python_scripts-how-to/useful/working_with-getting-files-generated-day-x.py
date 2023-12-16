#!/usr/bin/env python3

"""
This function is pulled from bigfix_status.py

Script checks the files in logdir for the past 5 days.
Sums up the files generated for each of the 5 days
"""


def get_db2_archive():
    logdir = "/opt/ibm/db2/backups/db2inst1/BFENT/NODE0000/LOGSTREAM0000/C0000000"
    if not os.path.exists(logdir) or not os.path.isdir(logdir):
        print("Archive directory not found")
        return

    days_ago = 5  # Specify the number of days to count logs for
    os.chdir(logdir)

    print("\nNumber of archived DB2 Transaction Logs per day for the last 5 days:")
    for ago in range(days_ago, 0, -1):
        day = (datetime.now() - timedelta(days=ago)).strftime("%b %-d")
        total_logs = 0
        for fn in os.listdir():
            mtime = os.stat(fn).st_mtime
            mday = time.ctime(mtime)
            if day in mday:
                total_logs += 1
        # total_logs = len([f for f in os.listdir() if f.endswith(".LOG") and day in f])
        print(f"Date {day} - Total Logs: {total_logs}")


def main():
    get_db2_archive()


if __name__ == "__main__":
    main()
