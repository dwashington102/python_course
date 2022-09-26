#!/usr/bin/env python3

"""
Script accepts user input that includes an email address
That email address is then checked againt LDAP server to confirm
if the user is a part of the USBExemption group

Date:       Version:    Changes:
7/30/2022   1.0         Initial build


Exit Codes:
    1 - Unexpected error when running subprocess module
    2 - LDAP server is unavailable
    3 - Error related to email address
    4 - import ldap module failed
"""

try:
    import colorama
    import subprocess
    import ldap
except ImportError as moderr:
    print(f"\n{moderr}...exit(4)")
    exit(4)


def main():
    try:
        test_network()
        emailaddr = str(get_email())
        do_ldapsearch(emailaddr)
    except KeyboardInterrupt:
        print('\nShutdown requested...exit(0)\n')
        exit(0)


def test_network():
    '''Test connection to LDAP server'''
    try:
        print('\nTesting connection to LDAP server...')
        pingcmd = ["ping", "-c1", "bluepages.ibm.com"]
        testcon = str(subprocess.call(pingcmd, shell=False,
                                      stdout=open('/dev/null', 'w'),
                                      stderr=subprocess.STDOUT))
    except FileNotFoundError as fnf:
        print(f"\n{fnf}...exit(1)")
        exit(1)
    except:
        print("\nDEBUG >>> ")
        raise
        exit(99)

    if testcon != "0":
        print('Network connection to LDAP server is unavailable...exit(2)')
        exit(2)

    print('Connection to LDAP Server - successful')


def get_email():
    try:
        emailaddr = str(input('User Email: '))
        print(f'\nChecking {emailaddr} to confirm if USB Exemption'
              'is available...')
        return emailaddr
    except RuntimeError:
        raise
        exit(3)


def do_ldapsearch(emailaddr):
    green = colorama.Fore.GREEN
    red = colorama.Fore.RED
    normal = colorama.Fore.RESET
    ldapBase = 'ou=bluepages,o=ibm.com'
    ldapInit = ldap.initialize("ldaps://bluepages.ibm.com")
    ldapSearch = "mail=" + emailaddr
    ldapSearchObject = 'cn=Mac Exemptions USB Read-only Opt-out,'

    resultList = ldapInit.search_s(ldapBase,
                                   ldap.SCOPE_SUBTREE,
                                   ldapSearch,
                                   ['ibm-allgroups'])
    if ldapSearchObject in str(resultList):
        print(green + 'Exemption FOUND')
    else:
        print(red + 'Exemption NOT FOUND')
    print(normal)
    exit(0)


if __name__ == "__main__":
    main()
