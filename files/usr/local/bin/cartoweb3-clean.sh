#!/bin/sh

# cleans old files: images, map results, PDF and SOAP XML cache
# in all cartoweb instances located in /var/www

for i in $(find /var/www/* -name clean.php 2>/dev/null |grep "cartoweb3/script" | egrep -v "auto_test|cartoweb_doc"); do
  php $i 300
done

