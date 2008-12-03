#!/bin/sh

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
if [ -e /usr/bin/mysqladmin ]; then
  # used ?
  if [ -d /var/lib/mysql ] && [ -z "$(find /var/lib/mysql -maxdepth 1 -type d ! -iname mysql )" ]; then
    # Running ?
    if /usr/bin/mysqladmin -uroot ping > /dev/null 2>&1; then
      /usr/bin/mysqldump --all-database |gzip > $BKPDIR/mysql-$DAY.sql.gz
    else
      echo 'mysqld not running'
      exit 1
    fi
  fi
fi
exit 0

