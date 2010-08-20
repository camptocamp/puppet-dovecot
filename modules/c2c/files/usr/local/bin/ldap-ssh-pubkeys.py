#!/usr/bin/env python

# Get ssh public keys

LDAPSERVER = 'ldap.lsn.camptocamp.com'

import os.path
import re, os, sys, shutil
from commands import getstatusoutput

def main(destdir):

    if sys.argv[2] == 'dev':
        users = getstatusoutput("ldapsearch -h %s -x -LLL -b 'cn=c2cdev,ou=Groups,dc=ldap,dc=c2c' memberUid" % LDAPSERVER)[1].split('\n')[1:-1]
    elif sys.argv[2] == 'all':
        users = getstatusoutput("ldapsearch -h %s -x -LLL -b 'ou=Users,dc=ldap,dc=c2c' uid | grep uid:" % LDAPSERVER)[1].split('\n')
    else:
        print "this can't happen"
        sys.exit(1)

    users = map(lambda x: x.split(': ')[1], users)

    for user in users:
        ssh = getstatusoutput("ldapsearch -h %s -x -tt -b 'uid=%s,ou=Users,dc=ldap,dc=c2c' sshPublicKey" % (LDAPSERVER, user))[1]
        regSsh = re.search(r"""sshPublicKey:< file://(.*)""", ssh)

        if regSsh:
            path =  os.path.join(destdir, user)
            os.mkdir(path, 0755)
            key = open(regSsh.groups()[0]).read()
            filePath = os.path.join(path,"%s.pub" % user)
            f = open(filePath, 'w')
            f.write(key+'\n')
            f.close()
            shutil.copyfile(filePath, os.path.join(path, "keys"))
        else:
            path = "None"

    # clean ssh temp files
    os.system("rm -f /tmp/ldapsearch-sshPublicKey-*")

def usage(name):
    print "usage: %s DIR (dev|all)" % name
    sys.exit(1)

if __name__=="__main__":
    
    if len(sys.argv) != 3:
        usage(sys.argv[0])

    keyDir = sys.argv[1]
    if sys.argv[1][-1] != '/':
      keyDir += '/'

    if not os.path.isdir(keyDir):
        print "%s must exists, create first !"
        usage(sys.argv[0])

    if sys.argv[2] not in ['dev', 'all']:
        print "invalid arg %s" % sys.argv[2]
        usage(sys.argv[0])
 
    # deletes olds first but exclude admin-keys
    os.system("find %s* -maxdepth 0 ! -name admin-keys -exec rm -fR {} \;" % keyDir)

    main(keyDir)
