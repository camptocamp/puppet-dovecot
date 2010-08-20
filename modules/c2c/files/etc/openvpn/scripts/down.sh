#!/bin/sh

echo "Openvpn DOWN script"

#resolvconf -d $1
dhclient
exit 0
