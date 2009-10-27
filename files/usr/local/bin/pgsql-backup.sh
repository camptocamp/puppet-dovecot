#!/bin/bash

BKPDIR="/var/backups/pgsql/"
TODAY=`date +%F`
DAY=`date +%A |tr 'A-Z' 'a-z'`
MONTH=`date +%B |tr 'A-Z' 'a-z'`
DEBUG="/bin/false" #DEBUG="/bin/echo"
TMPDIR=`mktemp -d -p $BKPDIR`

$DEBUG "*** Start PostgreSQL backup ***"
$DEBUG "dumping account objects"
pg_dumpall -U postgres --globals-only > $TMPDIR/ACCOUNT-OBJECTS.$TODAY.dump
$DEBUG "--"

for i in `psql -U postgres -c "select datname from pg_database where datname <> 'template0'" -t template1`
    do
        $DEBUG "dumping database $i"
        pg_dump -U postgres -C $i  > $TMPDIR/$i.$TODAY.dump
    done

$DEBUG "cleaning up..."
tar -C $TMPDIR -cz -f $BKPDIR/pgsql_$DAY.tar.gz `ls $TMPDIR`
rm -fr $TMPDIR
$DEBUG "*** End PostgreSQL backup *****"

if [ $(date +%d) == "01" ]; then
    cp $BKPDIR/pgsql_$DAY.tar.gz $BKPDIR/pgsql_$MONTH.tar.gz
fi 
