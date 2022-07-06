 #!/usr/bin/env python
'''
Script pulls the IntranetID from the /var/opt/beekeeper/beekeeper.ini file,
performs an ldapsearch using the IntranetID in order to pull the user's division number.

The division number is then appended to the /var/opt/beekeeper/beekeeper.ini file in this format:
    div=16


Exit Codes:
    1 -
    2 -
    3 -
    4 - Unable to write /tmp/beekeeper.ini
    5 - Unable to copy beekeeper.ini
    6 - Unable to move /tmp/beekeeper.ini 
    7 - /var/opt/beekeeper/beekeeper.ini NOT FOUND 
'''

import ldap
import os
import re
import shutil
import sys
from pathlib import Path

logfile = "bf_beekeeper_add-div.log"

try:
    from ibmlog.ibmlogger import IBMLogger
    log = IBMLogger(__name__, filename=logfile)
except:
    print("Unable to load IBMLogger")

def main():
    get_ldapInfo()
    copy_tmp_beekeeper()

def check_beekeeper():
    '''
    May be necessary to add a try-except to confirm /var/opt/beekeeper/beekeeper.ini exists
    '''

def get_ldapInfo():
    # May be necessary to add try-except to confirm LDAP connection before performing steps
    # Search Strings
    log.info("Starting get_ldapInfo")
    SEARCH_UID = '^IntranetID=.*'
    
    # Files
    beekeeperini="/var/opt/beekeeper/beekeeper.ini"
    
    # LDAP variables
    ldapBase = 'ou=bluepages,o=ibm.com'
    lattr = 'div'
    l = ldap.initialize("ldaps://bluepages.ibm.com")
    
    with open(beekeeperini, 'r') as beekeeper:
        idList = []
        for line in beekeeper:
            if re.search(SEARCH_UID, line):
                idList.append(line)
            else:
                pass
    
    idListSize = len(idList)
    if idListSize <= 0:
        log.info('IntranetID: NOT FOUND')
    else:
        log.info('IntranetID: FOUND')
        intranetid = idList.pop(0)
        intranetid = re.sub('.*=', '', intranetid)
        intranetid = re.sub('\n', '', intranetid)
        log.info("intranetid {}".format(intranetid))
        ldapSearch = "mail=" + intranetid
        log.info("ldapSearch {}".format(ldapSearch))

    result = l.search_s(ldapBase,ldap.SCOPE_SUBTREE,ldapSearch,['div'])
    for dn, div in result:
        division = div[lattr][0]
        beekeeperEntry = "div=" + division.decode("utf-8", "ignore")
        log.info("beekeeperEntry {}".format(beekeeperEntry))
        #beekeeperEntry = re.sub('\n', '', beekeeperEntry) 
        update_beekeeper(beekeeperEntry)
        
def update_beekeeper(beekeeperEntry):
    log.info("Starting update_beekeeper")
    try:
       input_file = "/var/opt/beekeeper/beekeeper.ini"
       output_file = '/tmp/beekeeper.ini'
       with open(input_file, 'r') as iFile, open(output_file, 'w') as oFile:
           for line in iFile:
               oFile.write(line)
               if line.startswith('employeeCountryCode='):
                   oFile.write(beekeeperEntry + '\n')
                   log.info("Added {} to {}".format(beekeeperEntry,output_file))
    except:
        log.info('Write Failed...exit(4)')
        sys.exit(4)

def copy_tmp_beekeeper():
    bkeeper_v1 = "/var/opt/beekeeper/beekeeper.ini"
    bkeeper_v2 = "/tmp/beekeeper.ini"

    bkeeper_v1Path = Path(bkeeper_v1)

    if bkeeper_v1Path.is_file():
        log.info("Existing {} FOUND".format(bkeeper_v1))
        try:
            shutil.copy("/var/opt/beekeeper/beekeeper.ini", "/tmp/bf_linuxatibm/beekeeper.ini")
            os.chmod("/var/opt/beekeeper/beekeeper.ini", 0o664)
            log.info('Beekeeper copy completed')
        except IOError as e:
            log.info('Beekeeper copy failed...rc=({})'.format(e))
            sys.exit(5)
        try:
            shutil.move("/tmp/beekeeper.ini", "/var/opt/beekeeper/beekeeper.ini")
            log.info('Beekeeper move completed')
        except IOError as e:
            log.info('Beekeeper move failed...rc=({})'.format(e))
            sys.exit(6)
    else:
        log.info("Existing {} NOT FOUND...exiting(7)".format(bkeeper_v1))
        sys.exit(7)
        

if __name__ == "__main__":
    main()
