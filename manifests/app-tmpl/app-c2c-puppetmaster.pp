# Class for specifics for srv-c2c-puppetmaster
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-puppetmaster {

  include puppet::master::passenger
  include mysql::server

  package{"git-email":
    ensure => present;
  }

  os::backported_package {"rake":
    ensure => latest,
  }

  c2c::sshuser::sadb {["ckaenzig", "marc", "mbornoz", "cjeanneret", "jbaubort", "mremy"]:
    groups  => "sysadmin",
  }

  common::concatfilepart {"sudoers.sysadmin":
    ensure => present,
    file => "/etc/sudoers",
    content => "## This part is managed by puppet
%sysadmin ALL=(ALL) ALL
##\n",
  }

  apache::vhost-ssl {"pm.camptocamp.net":
    ensure    => present,
    cert      => "/var/lib/puppetmaster/ssl/certs/pm.camptocamp.net.pem",
    certkey   => "/var/lib/puppetmaster/ssl/private_keys/pm.camptocamp.net.pem",
    cacert    => "/var/lib/puppetmaster/ssl/ca/ca_crt.pem",
    certchain => "/var/lib/puppetmaster/ssl/ca/ca_crt.pem",
  }

  apache::directive {"dashboard-local":
    ensure    => present,
    vhost     => "pm.camptocamp.net",
    directive => "
DocumentRoot /usr/share/puppet-dashboard/public

PassengerStatThrottleRate 120
RackAutoDetect On
RailsAutoDetect On

<Location />
  order deny,allow
  deny from all
  allow from 10.27.10.
  allow from 127.0.0.1
  allow from 128.179.66.9
</Location>

",
  }

}
