#!/bin/sh

TEMPFILE=$(tempfile)

logger "LDAP synchronization started"
# Get dump file
gunzip - > $TEMPFILE
# Load dump file
if [ -s $TEMPFILE ]; then
  /etc/init.d/slapd stop > /dev/null
  rm -f /var/lib/ldap/*
  cp /etc/ldap/DB_CONFIG /var/lib/ldap/
  cat $TEMPFILE | slapadd
  chown -R openldap: /var/lib/ldap
  /etc/init.d/slapd start > /dev/null
  rm $TEMPFILE
else
  logger "Error: LDAP dump file is empty or nonexistant"
fi

logger "LDAP synchronization finished"
