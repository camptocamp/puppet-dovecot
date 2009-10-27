#!/bin/sh
# file managed by puppet
function usage {
  echo "usage: $0 <VEID> <archive_name> [\"other tar arguments\"]"
  exit 0
}

if [ $# != 2 ]; then
  usage
fi

VEID=$1
CHROOTNAME=$2

if ! vzlist |grep -q $1; then
  echo "VE $VEID is not running, abort"
  exit 1
fi

vzctl exec $VEID 'apt-get clean'
vzctl exec $VEID 'crontab -u root -r'
vzctl exec $VEID '/usr/sbin/update-rc.d -f monit remove'
vzctl stop $VEID

cd /var/lib/vz/private/$VEID
tar cvzf /var/lib/vz/$CHROOTNAME.tar.gz -C ../ $VEID --exclude=home/* --exclude=root/* --exclude=var/backups/* --exclude=/var/apache-tomcat-5.5.26/logs/*  --exclude=/var/apache-tomcat-5.5.26/log/* $3

vzctl start $VEID
vzctl exec $VEID '/usr/sbin/update-rc.d monit defaults'
vzctl exec $VEID 'puppetd -t'

scp /var/lib/vz/$CHROOTNAME.tar.gz root@sa.camptocamp.com:/var/www/sa.camptocamp.com/htdocs/chroots/
rm /var/lib/vz/$CHROOTNAME.tar.gz

