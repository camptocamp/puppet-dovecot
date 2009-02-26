#!/usr/bin/env python

# List the GPG fingerprint

import os.path
import re, os, sys
from commands import getstatusoutput

def main():
    users = getstatusoutput("ldapsearch -h ldap.c2c -x -LLL -b 'cn=c2cdev,ou=Groups,dc=ldap,dc=c2c' memberUid")[1].split('\n')[1:-1]
    users = map(lambda x: x.split(': ')[1], users)

    for user in users:
        gpg  = getstatusoutput("ldapsearch -h ldap.c2c -x -b 'uid=%s,ou=Users,dc=ldap,dc=c2c' gpgPublicKey" % user)[1]
        regGpg = re.search(r"""gpgPublicKey: (.*)""", gpg)

        if regGpg:
            gpg = regGpg.groups()[0]
        else:
            gpg = "None"

        print "%s;%s" % (user,gpg)

if __name__=="__main__":
    main()
