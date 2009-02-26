#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-
# -*- mode: python; indent-tabs-mode: nil; tab-width: 4 -*-
# vim: set tabstop=4 shiftwidth=4 expandtab:

import sys, os, string, time
from getpass import getpass
from commands import getstatusoutput

_C2CPASSWD = "/usr/local/bin/c2cpasswd.py"
_USERMOD   = "/usr/sbin/smbldap-usermod"
_PASSWD    = "/usr/sbin/smbldap-passwd"
_SUDO      = "/usr/bin/sudo"

def matchPasswd(passwd1, passwd2):
    return passwd1 == passwd2

def checkPasswd(passwd):
    pwd = passwd.lower()
    if len(passwd) > 7 and pwd <> passwd:
        for i in passwd:
            if i in string.digits:
                return True
    return False

sudoUser = os.getenv("SUDO_USER")

if not sudoUser:
    os.system("%s %s" %(_SUDO, _C2CPASSWD))
else:
    try:
        print "Changing password for %s" %sudoUser
        passwd1 = getpass("New password : ")
        passwd2 = getpass("Retype new password : ")

        if not checkPasswd(passwd1):
            print "[Error] Passwords must be at least 8 characters long" 
            print "and must be a mix of uppercase, lowercase and at least 1 number !"
            sys.exit(1)
   
        if not matchPasswd(passwd1, passwd2):
            print "[Error] New passwords don't match !"
            sys.exit(1)
   
        pipe = os.popen("%s %s > /dev/null" %(_PASSWD, sudoUser), 'w')
        pipe.write("%s\n" %passwd1)
        pipe.write("%s\n" %passwd1)
        
        # force no expiration date
        os.system("%s -B 0 %s" %(_USERMOD, sudoUser))
        
    except KeyboardInterrupt:
        print
        sys.exit(1)
