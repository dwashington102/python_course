#!/usr/bin/env python3

import socket

devhostname = socket.gethostname()
devipaddr = socket.gethostbyname(devhostname)

print(f"DEBUG >>> IP Address: {devipaddr} ")
