#!/bin/sh

PATH="/bin:/sbin:/usr/bin:/usr/sbin"
MYDIR="/var/lib/mysql"
BKPDIR="/var/backups/mysql"
DAY=`date +%A |tr 'A-Z' 'a-z'`

if [ ! -e /usr/bin/mysqladmin ] || ! /usr/bin/mysqladmin -uroot ping > /dev/null 2>&1; then
  echo "mysqld isn't running"
  exit
fi

/usr/bin/mysqldump --all-database |gzip > $BKPDIR/mysql-$DAY.sql.gz
