#!/usr/bin/env python
import ldap
#email = "user@xxx.com"
lattr = 'div'
uid = 'userid'
l = ldap.initialize("ldaps://bluepages.same.com")
qResult = l.search_s("ou=bluepages,o=same.com",ldap.SCOPE_SUBTREE,'(uid=' + uid + ')', ['mail'])

print('LDAP Info:\n')
print(qResult)


"""
Code from story https://jsw.ibm.com/browse/LINUXIBM-12503

result = l.search_s("ou=bluepages,o=same.com",ldap.SCOPE_SUBTREE,'(mail=userid@us.same.com)',['div'])
for dn, div in result:
    division = div[lattr][0]
    print("Division: " + division.decode("utf-8", "ignore"))
"""
