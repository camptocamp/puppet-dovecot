#!/bin/bash
if ! [ $# = 4 ]; then
  echo "usage:"
  echo "  $0 <user> <password> <server> <remote schema>"
  echo
  exit 1
fi
USR=$1
PASWD=$2
SRV=$3
SCHEM=$4
for file in `echo /var/backups/{tinyerp,pgsql}/*.tar.gz`; do 
  echo "put $file `basename $file`" | smbclient -U "${USR}%${PASWD}" -I $SRV $SCHEM  > /dev/null 2>&1 || echo "problem uploading $file to NAS"
  sleep 1
done
exit 0
