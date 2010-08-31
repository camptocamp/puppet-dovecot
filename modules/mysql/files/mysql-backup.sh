#!/bin/sh
# file managed by puppet

case "$1" in
  week)
    DAY=$(date +%A |tr 'A-Z' 'a-z')
    ;;
  month)
    DAY=$(date +%d)
    ;;
  year)
    DAY=$(date +%j)
    ;;
  *)
    echo "Usage: $0 (week|month|year)"
    exit 1
    ;;
esac

PATH="/bin:/sbin:/usr/bin:/usr/sbin"
MYDIR="/var/lib/mysql"
BKPDIR="/var/backups/mysql"

# Installed ?
if [ -e /usr/bin/mysqladmin ] && [ -e /usr/bin/mysqldump ]; then
  # used ?
  if [ -d /var/lib/mysql ] && [ -n "$(find /var/lib/mysql -maxdepth 1 -type d ! -iname mysql ! -iname test )" ]; then
    # Running ?
    if /usr/bin/mysqladmin -s ping > /dev/null; then
      /usr/bin/mysqldump --all-database --extended-insert > $BKPDIR/mysql.sql && nice -n 19 gzip -9 $BKPDIR/mysql.sql && mv -f $BKPDIR/mysql.sql.gz $BKPDIR/mysql-$DAY.sql.gz
      exit $?
    else
      echo 'mysqld not running'
      exit 1
    fi
  else
    # no databases to backup ? no problem
    exit 0
  fi
else
  echo "mysqladmin/mysqldump missing. Are you sure this cron must run ?"
  exit 1
fi
