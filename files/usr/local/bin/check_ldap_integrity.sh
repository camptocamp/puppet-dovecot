#!/bin/sh

LIMIT="Size limit exceeded"
LDAPLSN="ldap.lsn.camptocamp.com"
LDAPCBY="ldap.cby.camptocamp.com"
LDAPTLS="ldap.tls.camptocamp.com"

# check if size limit exceede
function check_limit {
if ldapsearch -x -h $1 |grep -q "$LIMIT"; then
cat << EOF
$LIMIT on $1 !!

To correct this problem, it is necessary to increase
the sizelimit in slapd.conf and to restart slapd with /etc/init.d/slapd restart
EOF
exit
fi
}

function unsynchronize {
cat << EOF

To correct this problem :

1. do a dump (ldap.dump) with slapcat on the master
2. stop slapd on unsynchronized server
3. remove all data with 'find /var/lib/ldap/* ! -name DB_CONFIG -exec rm -f {} \;'
4. restore the dump with 'cat ldap.dump |slapadd'
5. set rights with 'chown -R openldap: /var/lib/ldap'
6. restart slapd
7. restart this script to check integrity

EOF
}

check_limit $LDAPLSN
check_limit $LDAPCBY
check_limit $LDAPTLS

md5_master=$(ldapsearch -x -h $LDAPLSN |md5sum)
md5_oco=$(ldapsearch -x -h $LDAPCBY |md5sum)
md5_tls=$(ldapsearch -x -h $LDAPTLS |md5sum)

# check slave in chambery
if [[ $md5_master != $md5_oco ]]; then
    echo "$LDAPCBY is unsynchronized !!"
    unsynchronize
    exit
fi

# check slave in toulouse
if [[ $md5_master != $md5_tls ]]; then
    echo "$LDAPTLS is unsynchronized !!"
    unsynchronize
    exit
fi
