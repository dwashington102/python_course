#!/usr/bin/env python3

import logging

"""
Levels of logging
- DEBUG
- INFO
- WARNING
- ERROR
- CRITICAL

By default DEBUG and INFO messages are surpressed.
To enable all messages above DEBUG
logging.basicConfig(filename="/tmp/my.log",filemode=a,level=logging.debug)

filemods (a=append (default), w=write)

Default format:
logging_msg_level:root:debug message
"""


def main():
    only_debug_above()
    only_error_above()


def only_debug_above():
    # Truncates file due to filemode="w" then write all messages >= DEBUG
    logging.basicConfig(filename="/tmp/my.log",
                        format="%(asctime)s %(levelname)-8s %(message)s",
                        filemode="w",
                        level=logging.DEBUG)
    logging.info("DEBUG LEVEL: DEBUG and above with WRITE action")
    logging.debug("debug message")
    logging.info("info message")


def only_error_above():
    # Appends to log file due to filemode="a" writes all messages >= ERROR
    logging.basicConfig(filename="/tmp/my.log",
                        filemode="a",
                        level=logging.ERROR)
    logging.info("DEBUG LEVEL: ERROR and above with APPEND action")
    logging.debug("debug message")
    logging.info("info message")
    logging.warning("warn message")
    logging.error("error message")
    logging.critical("critical message")


if __name__ == "__main__":
    main()
