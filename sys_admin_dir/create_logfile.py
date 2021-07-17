#!/usr/bin/env python3
#

from os import makedirs
from time import sleep
from getpass import getuser

# Calling functions for other Python scripts
from logfile_tstamp import get_timestamp

def createlog():
    logtime=get_timestamp()
    getUserid=getuser()
    logdir='/cronlogs'
    logpath='/tmp/'+getUserid+logdir+'/'+logtime+'/'
    lognetworkstatus=logpath+logtime+'_NetworkManager_status.log'
    sleep(3)
    makedirs(logpath)
