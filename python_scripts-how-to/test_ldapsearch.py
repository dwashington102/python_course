#!/usr/bin/env python3

import os
import ldap


def do_ldapsearch():
    print("Starting do_ldapsearch()")
    # LDAP variables
    ldapBase = 'ou=bluepages,o=ibm.com'
    l = ldap.initialize("ldaps://bluepages.ibm.com")
    ldapSearch = "mail=washingd@us.ibm.com"

    print(f"DEBUG >>> ldapSearch")
    print("resultList attempt")
    resultList = l.search_s(ldapBase, ldap.SCOPE_SUBTREE,
                            ldapSearch, ['ibm-allgroups'])

    if len(resultList) <= 0:
        print("resultList-2 attempt")
        try:
            l = ldap.initialize("ldap://bluepages.ibm.com")
            resultList = l.search_s(ldapBase, ldap.SCOPE_SUBTREE,
                                ldapSearch, ['ibm-allgroups'])

        except ldap.SERVER_DOWN as ldapdown:
            print(ldapdown)
            print("LDAP SEARCH issue...exit(109)")
            exit(109)

    print(f"resultList size: {len(resultList)}")
    print(f"{resultList}")

    search = "cn=IBMLinuxUsers"
    if search in str(resultList):
        print("FOUND")


def main():
    print("Starting main()")
    do_ldapsearch()

if __name__ == '__main__':
    main()
