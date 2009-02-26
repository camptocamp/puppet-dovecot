#!/usr/bin/env python
# -*- coding: iso-8859-15 -*- 
# -*- mode: python; indent-tabs-mode: nil; tab-width: 4 -*-
# vim: set tabstop=4 shiftwidth=4 expandtab:

import sha
import sys, os, re, os.path
from getpass import getpass
from commands import getstatusoutput
from random import randrange
from binascii import b2a_base64, a2b_base64


### [ ldap-attribut,     legend,                  example,                       value]
initUserInfos = [
    ['uid',             "Utilisateur",          "cphilipona",                       ""],
    ['uidNumber',       "UID de l'utilisateur", "prend le suivant par defaut",      "auto"],
    ['givenName',       'Prenom' ,              "Claude",                           ""],
    ['sn',              'Nom',                  "Philipona",                        ""],
    ['mail',            'Email',                "claude.philipona@camptocamp.com",  ""],
]

initExternalInfos = [
    ['uid',             "Utilisateur",          "cphilipona",                       ""],
    ['givenName',       'Prenom' ,              "Claude",                           ""],
    ['sn',              'Nom',                  "Philipona",                        ""],
    ['mail',            'Email',                "claude.philipona@camptocamp.com",  ""]
]

initMailInfos = [
    ['uid',             "Utilisateur",          "cphilipona",                       ""],
    ['givenName',       'Prenom' ,              "Claude",                           ""],
    ['sn',              'Nom',                  "Philipona",                        ""],
    ['domain',          'Domaine',              "camptocamp.org",                   ""]
]

initGroups = [
    ['c2cdev',          'groupe c2cdev',            "Oui ou Non",        "O"],
    ['www-data',        'groupe www-data',          "Oui ou Non",        "O"],
    ['sigdev',          'dev cartoweb',             "Oui ou Non",        "O"],
    ['codir',           'groupe direction',         "Oui ou Non",        "N"],
    ['suisse',          'en Suisse',                "Oui ou Non",        "N"],
    ['france',          'en France',                "Oui ou Non",        "N"]
]
                            
userAttributes = """
dn: uid=%s,ou=Users,%s
objectClass: top
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: sambaSamAccount
ObjectClass: CourierMailAccount
objectClass: phpgwAccount
phpgwAccountStatus: A
phpgwAccountType: u
phpgwAccountExpires: -1
mailbox: /home/%s/Maildir/
cn: %s %s
"""

mailAttributes = """
dn:uid=%s,ou=mailUsers,dc=ldap,dc=c2c
uid: %s
givenName: %s
sn: %s
cn: %s
userPassword: %s
loginShell: /bin/false
uidNumber: 5000
gidNumber: 5000
homeDirectory: /var/vmail
shadowMin: -1
shadowMax: 999999
shadowWarning: 7
shadowInactive: -1
shadowExpire: -1
shadowFlag: 0
objectClass: top
objectClass: person
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
objectClass: CourierMailAccount
mailbox: /var/vmail/%s/%s/
mail: %s.%s@%s 
"""

externalAttributes = """
dn:uid=%s,ou=externalUsers,dc=ldap,dc=c2c
uid: %s
givenName: %s
sn: %s
cn: %s
gidNumber: 1029
objectClass: top
objectClass: person
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
homeDirectory: /tmp
uidNumber: 1029
userPassword: %s
mail: %s
"""

# informations de connexion ldap
_LDAPASSWD          = ""
_HOST            = "ldapmaster.dmz.lsn"
_BASEDN          = "dc=ldap,dc=c2c"
_ROOTDN          = "cn=admin,dc=ldap,dc=c2c"
_SEARCHGROUP     = "ou=Groups,dc=ldap,dc=c2c"
_OPTIONS         = "-x -w %s"
_LDAPPASSWDPATH  = "/root/.ldap-passwd"

# chemin programmes externes
_GROUPADD        = "/usr/sbin/smbldap-groupadd"
_USERADD         = "/usr/sbin/smbldap-useradd"
_GROUPMOD        = "/usr/sbin/smbldap-groupmod"
_PASSWD          = "/usr/sbin/smbldap-passwd"
_LDAPSEARCH      = "/usr/bin/ldapsearch"
_LDAPMODIFY      = "/usr/bin/ldapmodify"
_LDAPADD         = "/usr/bin/ldapadd"
_PWGEN           = "/usr/bin/pwgen"

# syntaxes specifiques de commandes
_GROUPSEARCH = "%s -h %s %s -LLL -D '%s' -b '%s' cn=" %(_LDAPSEARCH,_HOST, _OPTIONS,_ROOTDN,_SEARCHGROUP) 
_USERMODIFY = "%s -h %s %s -D '%s' -f" %(_LDAPMODIFY, _HOST, _OPTIONS,_ROOTDN)

# log password informations
_PASSWDLOG = "/var/log/.passwd-ldap.log"

def generate_salt():
    salt = ''
    for n in range(4):
        salt += chr(randrange(256))
    return salt

# password SSHA
def encrypt(password):
    password = str(password)
    salt = generate_salt()
    return b2a_base64(sha.new(password + salt).digest() + salt)[:-1]

# controle la bonne execution des commandes externes
def checkError (status, output, msg) :
    if status > 0 :
        print "[erreur] sur : %s" %msg
        print "[traceback]"
        print output
        sys.exit(1)
    else :
        print "  ", msg.ljust(55), "ok"

def addGroup(uidNumber,uid):
    if uidNumber != "auto":
        status, output = getstatusoutput("%s -a -g %s %s" %(_GROUPADD,uidNumber,uid))
        checkError(status, output, "Ajout d'un utilisateur avec l'UID %s" %uidNumber)
        return uidNumber
    else:
        print "%s -a %s" %(_GROUPADD,uid)
        s,o = getstatusoutput("%s -a %s" %(_GROUPADD,uid))
        checkError(s, o, "Ajout d'un utilisateur avec le prochain UID libre")
        cmd = _GROUPSEARCH %_LDAPASSWD
        s,o = getstatusoutput("%s%s" %(cmd,uid))
        reg = re.compile(r"""gidNumber: (?P<gidNumber>.*?)\n""")
        newUidNumber = reg.search(o).group('gidNumber')
        checkError(s, o, "Le nouveau UID est le %s" %newUidNumber)
        return newUidNumber

def addUserToGroup(infos,user):
    for key, value in infos.items():
        if value in ["O","o"]:
            s,o = getstatusoutput("%s -m %s %s" % (_GROUPMOD,user,key))
            checkError(s, o, "Ajout de l'utilisateur %s dans le groupe %s" % (user, key))
    
def addC2cUser(infos):
    # creation d'un groupe avec gid=uid
    infos['uidNumber'] = addGroup(infos['uidNumber'],infos['uid'])

    cmd = "%s -a -g %s -c '%s %s' -B 0 -G '%s' %s"
    status, output = getstatusoutput(cmd %(_USERADD, infos['uidNumber'],
                                infos['givenName'], infos['sn'], 'Domain Users', infos['uid']))
    checkError(status, output, "Ajout de l'utilisateur %s" %infos['uid'])

    # creation et affectation du password
    passwd = genPasswd()
    pipe = os.popen("%s %s > /dev/null" %(_PASSWD, infos['uid']), 'w')
    pipe.write("%s\n" %passwd)
    pipe.write("%s\n" %passwd)

    passwdLog = open(_PASSWDLOG, 'a')
    passwdLog.write("[USER]\tusername: %s \t password: %s\n" %(infos['uid'],passwd))
    passwdLog.close()

    # ajout d'attributs specific camptocamp
    addAttributes(infos)

def addUser(infos, strLdif):
    tmpLdif = "/tmp/ldif.tmp"
    ldif = open(tmpLdif,'w')
    ldif.write(strLdif)
    ldif.close()

    cmd = "%s -h %s -x -D '%s' -w %s -f %s" %(
                    _LDAPADD,
                    _HOST,
                    _ROOTDN,
                    _LDAPASSWD, tmpLdif)

    status, output = getstatusoutput(cmd)
    checkError(status, output, "Ajout de l'utilisateur %s" %infos['uid'])
    os.remove(tmpLdif)

def addExternalUserNi(firstname, lastname, username, email):
    infos = {}
    infos['uid'] = username

    if os.path.exists(_LDAPPASSWDPATH):
        global _LDAPASSWD
        _LDAPASSWD = open(_LDAPPASSWDPATH).read().strip()
    else:
        print "file %s not found !" % _LDAPPASSWDPATH
        sys.exit(1)

    passwd = genPasswd()
    
    strLdif = externalAttributes %(
              username,
              username,
              firstname,
              lastname,
              firstname + " " + lastname,
              passwd,
              email)
    
    addUser(infos, strLdif)

    print
    print "Name: %s %s" % (firstname, lastname)
    print "Username: %s" % username 
    print "Password: %s" % passwd
    print

    passwdLog = open(_PASSWDLOG, 'a')
    passwdLog.write("[EXTERNAL-USER]\tusername: %s \t password: %s\n" %(infos['uid'],passwd))
    passwdLog.close()

def addExternalUser(infos):
    passwd = genPasswd()
    strLdif = externalAttributes %(
                    infos['uid'],
                    infos['uid'],
                    infos['givenName'],
                    infos['sn'],
                    infos['givenName'] + " " + infos['sn'], 
                    passwd,
                    infos['mail'])      
    
    addUser(infos, strLdif)
    print
    print "-------------------------------------------------------------"
    print "Template de mail a envoyer a l'adresse: %s\n" %infos['mail']
    print "Nom d'utilisateur: %s" %infos['uid']
    print "Mot de passe: %s" %passwd
    print "\nChangement du mot de passe a l'adresse:\n TODO"
    print

    passwdLog = open(_PASSWDLOG, 'a')
    passwdLog.write("[EXTERNAL-USER]\tusername: %s \t password: %s\n" %(infos['uid'],passwd))
    passwdLog.close()
             
def addMailUser(infos):
    passwd = genPasswd()
    sshaPasswd = "{SSHA}%s" %encrypt(passwd)

    strLdif = mailAttributes %(
                    infos['uid'],
                    infos['uid'],
                    infos['givenName'],
                    infos['sn'],
                    infos['givenName'] + " " + infos['sn'],
                    sshaPasswd,
                    infos['domain'],
                    infos['uid'],
                    infos['givenName'].lower(), infos['sn'].lower(), infos['domain'])
    
    addUser(infos, strLdif)
    passwdLog = open(_PASSWDLOG, 'a')
    passwdLog.write("[MAIL-USER]\tusername: %s \t password: %s\n" %(infos['uid'],passwd))
    passwdLog.close()
            
def genPasswd():
    status,output = getstatusoutput("%s -n -c 8 1" %_PWGEN)
    checkError(status, output, "Generation du password : %s" %output)
    return output

def addAttributes(infos):
    tmpFile = "/tmp/tmp.ldif"
    ldif = open(tmpFile,'w')
    
    # attributs indispensables
    strLdif = userAttributes %(infos['uid'], _BASEDN, infos['uid'], infos['givenName'], infos['sn'])
    ldif.write(strLdif)

    # attributs demande interactivement
    for key in infos.keys() :
        ldif.write("%s: %s\n" %(key,infos[key]))
    ldif.close()

    cmd = _USERMODIFY %_LDAPASSWD
    status, output = getstatusoutput("%s %s > /dev/null && rm -f %s" 
                                           %(cmd, tmpFile, tmpFile))
    checkError(status, output, "Ajout des champs specifiques Camptocamp")

def manageForm(initInfos, msg):
    try:
        print
        print " Ajouter un compte %s (exemple) [valeur par defaut]" %msg
        print " ####################################################"
        for key,value in enumerate(initInfos) :

            again = True
            while again:
                ask = raw_input(" %s (%s) [%s] : " %(initInfos[key][1],
                                                     initInfos[key][2],   
                                                     initInfos[key][3]))
                if ask == "":
                    initInfos[key][3] = initInfos[key][3]
                else : initInfos[key][3] = ask
                    
                if initInfos[key][3] <> "": again = False
    
        infos={}
        print "\n ############# Resume ###############################"
        for id,legend,example,value in initInfos :
            print " %s : %s" %(legend.ljust(20),value)
            infos[id] = value
        print " ####################################################\n"
    
        ask = ""
        ask = raw_input(" Ces informations sont-elles corrects [O/n] : ")
    
    except KeyboardInterrupt:
        print 
        sys.exit(1)

    for key,value in infos.items():
        if value == "undefined":
            del infos[key]
        
    return ask not in ['y','Y','O','o',""], infos

def checkLdapAdmin():
    passwd = getpass(" LDAP admin password : ")
    status, output = getstatusoutput(
       "%s -LLL -h %s -x -w %s -D '%s' cn=admin" %(
       _LDAPSEARCH, _HOST, passwd, _ROOTDN))
    if status <> 0:
        print " Password incorrect !"
        sys.exit(1)

    return passwd

def checkUserType():
    type = ""
    print
    print " [1]\tCompte Camptocamp (Users)"
    print " [2]\tCompte Mail (mailUsers)"
    print " [3]\tCompte Externe (externalUsers)"
    print
    while type not in ["1", "2", "3"]:
        type = raw_input(" Quel type de compte ? : ")
        
    return type

def form(initInfos, msg):
    again = True
    while(again):
        again, infos = manageForm(initInfos, msg)
    
    return infos

if __name__=="__main__":

    try:
        if os.getuid() != 0:
            print "not root!"
            sys.exit(1)

        if len(sys.argv) > 1 and sys.argv[1] == "--help":
            print "usage: %s --external firstname lastname username email" % sys.argv[0]
            sys.exit()

        if len(sys.argv) == 6 and sys.argv[1] == "--external":
            addExternalUserNi(sys.argv[2],
                              sys.argv[3],
                              sys.argv[4],
                              sys.argv[5])
            sys.exit()

        # demande password du ldap
        _LDAPASSWD = checkLdapAdmin()

        # type d'utilisateur
        type = checkUserType()

        if type == "1":
            infos = form(initUserInfos, "Camptocamp")
            currentUser = infos['uid']
            addC2cUser(infos)
            addUserToGroup(form(initGroups, "dans les groupes"), currentUser)
        elif type == "2":
            addMailUser(form(initMailInfos, "Mail"))
        elif type == "3":
            addExternalUser(form(initExternalInfos, "Externe"))
    except KeyboardInterrupt:
        print
        sys.exit(1)
