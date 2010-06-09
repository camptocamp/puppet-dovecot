#!/bin/bash

echo "Openvpn UP script"

TEMP=`mktemp`
for var in $(printenv | grep foreign_option | cut -d'=' -f1)
do
  case `echo ${!var} | cut -d' ' -f2` in
    DNS)
      echo "nameserver " $(echo ${!var} | cut -d' ' -f3) >> $TEMP
    ;;

    DOMAIN)
      echo "search " $(echo ${!var} | cut -d' ' -f3) >> $TEMP
    ;;

    WINS)
      echo "WINS support not yet implemented"
    ;;
  esac
done

#cat $TEMP | resolvconf -a $1
cat $TEMP > /etc/resolv.conf
rm $TEMP
sudo -k
