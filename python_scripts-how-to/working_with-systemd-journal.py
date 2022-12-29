#!/usr/bin/env python3

from systemd import journal


def main():
    get_last_five_entries()


def get_last_five_entries():
    # Create a JournalReader object, specify the number of entries to retrieve
    reader = journal.Reader()
    reader.this_boot()
    reader.log_level(journal.LOG_INFO)
    reader.add_match(_SYSTEMD_UNIT="sshd.service")
    reader.seek_tail()
    reader.get_previous(15)

    # Iterate through the entries and print them with the timestamps
    # converted to a human-readable format
    for entry in reader:
        # Convert the timestamp to a datetime object
        entryDate = entry['__REALTIME_TIMESTAMP']
        print(f'{entryDate}: {entry["MESSAGE"]}')


if __name__ == "__main__":
    main()
