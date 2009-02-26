#!/bin/sh
DIR=/var/backups/ldap
/usr/sbin/slapcat |gzip > $DIR/ldap_`date +%A |tr 'A-Z' 'a-z'`.gz
