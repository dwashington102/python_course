#!/usr/bin/env python3

from datetime import datetime


def get_timestamp():
    tStamp=datetime.now()
    tNow=(tStamp.strftime("%Y%m%d%H%M"))
    return tNow
