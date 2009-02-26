#!/bin/sh

if [ -d /etc/puppet/ssl ] && [ -d /var/lib/puppet/ssl ]; then
        rm -rf /var/lib/puppet/ssl
        mv /etc/puppet/ssl /var/lib/puppet/ssl
fi

if [ -L /etc/puppet/ssl ]; then
  rm /etc/puppet/ssl
fi
