#!/bin/sh

DIR="/etc /root /usr/local/bin var/local/backup"

for d in $DIR; do
    find $d -name .svn -exec rm -fR {} \;
done
