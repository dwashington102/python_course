#!/usr/bin/env python3

'''
Script pulls the IntranetID from the /var/opt/beekeeper/beekeeper.ini
file, performs an ldapsearch using the IntranetID, if the search
fails the script pulls the uid from the beekeeper.ini file, performs
and ldapsearch gathering the correct IntranetID.

Using the correct IntranetID, the beekeeper.ini file is updated
replacing the failing IntranetID with the valid IntranetID.

Associated Jira Story:
    https://jsw.ibm.com/browse/LINUXIBM-12737

Exit Codes:
    1 - /var/opt/beekeeper/beekeeper.ini NOT FOUND
    2 - ldap connection fails
    3 - IntranetID nor uid found in beekeeper.ini
    4 - ldapsearch for uid failed
    5 - Write to /tmp/beekeeper.ini failed
    6 - beekeeper.ini IntranetID matches mail address in LDAP
    7 - copy beekeeper.ini to /tmp/bf_linuxatibm/beekeeper.ini failed
    8 - move /tmp/beekeeper.ini failed
'''

import ldap
import os
import re
import shutil
import sys
from pathlib import Path

logfile = "bf_beekeper-invalid-intranetid.log"

try:
    from ibmlog.ibmlogger import IBMLogger
    log = IBMLogger(__name__, filename=logfile)
except AttributeError:
    import logging
    logfile = "/tmp/{}".format(logfile)
    logging.basicConfig(filename=logfile, level=logging.DEBUG)
    log = logging
    log.warning("unable to load ibmlogger, using standard logging instead ({})".format(logfile))


def main():
    bkeeperini = check_beekeeper()
    validEmail = test_intranetid(bkeeperini)
    # log.info("VALID EMAIL: {}".format(validEmail))
    update_beekeeper(validEmail)
    copy_tmp_beekeeper()



def check_beekeeper():
    '''
    check_beekeeper() - Performs a is.file check of the
    var/opt/beekeeper/beekeeper.ini
    returns bkeeperini variable
    '''
    log.info("Starting check_beekeeper()")
    bkeeperini = "/var/opt/beekeeper/beekeeper.ini"
    bkeeperiniPath = Path(bkeeperini)

    if bkeeperiniPath.is_file():
        log.info("Existing {} FOUND".format(bkeeperini))
        return(bkeeperini)
    else:
        log.critical("Existing {} NOT FOUND...exit(1)".format(bkeeperini))
        sys.exit(1)


def test_intranetid(bkeeperini):
    '''
    test_intranetid() - Searches the beekeeper.ini file for the string
    IntranetID and uid.
    Performs an ldapsearch using the IntranetID, if the ldapsearch
    results in an array with size 0 - an ldapsearch using uid is
    attempted.  Both ldapsearchs gather the ldapEmail associated.
    returns ldapEmail
    '''
    log.info("Starting test_intranetid()")
    searchEmail = "^IntranetID=.*"
    searchUid = "^uid=.*"
    ldapBase = "ou=bluepages,o=ibm.com"
    ldapattr = 'mail'
    ldapattruid = 'uid'
    l = ldap.initialize("ldaps://bluepages.ibm.com")

    with open(bkeeperini) as bkeeperini:
        emailList = []
        uidList = []
        for line in bkeeperini:
            if re.search(searchEmail, line):
                log.info("IntranetID entry: {}".format(line))
                emailList.append(line)
            elif re.search(searchUid, line):
                log.info("UID entry: {}".format(line))
                uidList.append(line)
            else:
                pass

    emailListSize = len(emailList)
    if emailListSize <= 0:
        log.info("IntranetID: NOT Found")
    else:
        intranetid = emailList.pop(0)
        intranetid = re.sub(".*=", "", intranetid)
        intranetid = re.sub("\n", "", intranetid)
        ldapSearch = "mail=" + intranetid
        log.info("ldapsearch string:  {}".format(ldapSearch))

    result = l.search_s(ldapBase, ldap.SCOPE_SUBTREE, ldapSearch)
    resultSize = len(result)
    if resultSize <= 0:
        log.warning("LDAP search failed for address {}".format(ldapSearch))
        log.info("Attempting ldapSearch using uid ---")
        uidListSize = len(uidList)
        if uidListSize <= 0:
            log.critical("UID NOT FOUND in beekeeper.ini...exit(3)")
            sys.exit(3)
        else:
            uid = uidList.pop(0)
            uid = re.sub(".*=", "", uid)
            uid = re.sub("\n", "", uid)
            ldapSearchUid = "uid=" + uid
            log.info("ldapSearchUid string: {}".format(ldapSearchUid))
        result = l.search_s(ldapBase, ldap.SCOPE_SUBTREE, ldapSearchUid)
        resultSize = len(result)
        if resultSize <= 0:
            log.critical("LDAP search failed for uid {}".format(ldapSearchUid))
            exit(4)
        else:
            for dn, mail in result:
                emailFound = mail[ldapattr][0]
                ldapEmail = emailFound.decode("utf-8", "ignore")
                # ldapUid = uidFound.decode("utf-8", "ignore")
                # log.info("uid: {}".format(ldapUid))
                log.info("LDAP email id returned: {}".format(ldapEmail))
                return(ldapEmail)
    else:
        for dn, mail in result:
            emailFound = mail[ldapattr][0]
            ldapEmail = emailFound.decode("utf-8", "ignore")
            log.info("Current intranetid setting in beekeeper.ini: {}".format(intranetid))
            log.info("LDAP email id: {}".format(ldapEmail))
            if intranetid == ldapEmail:
                log.info("No updates to the beekeeper.ini are necessary")
                log.info("IntranetID matches mail address in LDAP...exit(6)")
                sys.exit(6)
            else:
                return(ldapEmail)


def update_beekeeper(validEmail):
    '''
    Generates a /tmp/beekeeper.ini file by replacing the invalid
    entry for IntranetID with the valid ldapEmail address
    '''
    log.info("Starting update_beekeeper()")
    try:
        input_file = "/var/opt/beekeeper/beekeeper.ini"
        output_file = '/tmp/beekeeper.ini'
        with open(input_file, 'r') as iFile, open(output_file, 'w') as oFile:
            for line in iFile:
                if line.startswith('IntranetID='):
                    updatedline = re.sub('=.*', '=' + validEmail, line)
                    oFile.write(updatedline)
                else:
                    oFile.write(line)
    except IOError:
        log.error('Write to {} failed...exit(5)'.format(output_file))
        sys.exit(5)
    log.info("{} generated".format(output_file))


def copy_tmp_beekeeper():
    log.info("Starting copy_tmp_beekeeper()")
    bkeeper_v1 = "/var/opt/beekeeper/beekeeper.ini"
    bkeeper_v2 = "/tmp/beekeeper.ini"

    bkeeper_v1Path = Path(bkeeper_v1)
    if bkeeper_v1Path.is_file():
        log.info("Existing {} FOUND".format(bkeeper_v1))
        try:
            shutil.copy("/var/opt/beekeeper/beekeeper.ini",
                        "/tmp/bf_linuxatibm/beekeeper.ini")
            os.chmod("/var/opt/beekeeper/beekeeper.ini", 0o664)
            log.info('{} copy completed'.format(bkeeper_v1))
        except IOError as e:
            log.error('Beekeeper copy failed...rc=({})'.format(e))
            sys.exit(7)
        try:
            shutil.move("/tmp/beekeeper.ini",
                        "/var/opt/beekeeper/beekeeper.ini")
            os.chmod("/var/opt/beekeeper/beekeeper.ini", 0o664)
            log.info('{} move completed'.format(bkeeper_v2))
        except IOError as e:
            log.error('Beekeeper move failed...rc=({})'.format(e))
            sys.exit(8)
    else:
        log.critical("Existing {} NOT FOUND...exiting(7)".format(bkeeper_v1))
        sys.exit(1)


if __name__ == "__main__":
    main()
