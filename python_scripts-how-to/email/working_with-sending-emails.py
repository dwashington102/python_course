#!/usr/bin/env python3

"""
Function taken from bigfix_status.py

/root/bfadmins.txt contains addresses using this syntax:
bubba@eom.com rick@eom.com morty@eom.com

"""

import socket
import smtplib

from email.message import EmailMessage


def send_email():
    fqhostname = socket.gethostname().split(".")
    emailsender = f"{fqhostname[0]}"

    try:
        addresses = "/root/bfadmins.txt"
        with open(addresses) as bfa:
            bfraw = bfa.read()
    except FileNotFoundError as fnf:
        print(f"Exception {fnf}")
        exit(110)

    bfadmins = bfraw.split(" ")

    emailContent = "/var/log/ibm/bigfix_status.log"
    with open(emailContent) as ec:
        msg = EmailMessage()
        msg.set_content(ec.read())

    msg["Subject"] = "BigFix Status Summary"
    msg["From"] = f"{emailsender}"
    msg["To"] = ", ".join(bfadmins)

    s = smtplib.SMTP('localhost')
    s.send_message(msg)
    s.quit()


def main():
    send_email()


if __name__ == "__main__":
    main()
