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
    cert      => "/var/lib/puppet/ssl/certs/pm.camptocamp.net.pem",
    certkey   => "/var/lib/puppet/ssl/private_keys/pm.camptocamp.net.pem",
    cacert    => "/var/lib/puppet/ssl/ca/ca_crt.pem",
    certchain => "/var/lib/puppet/ssl/ca/ca_crt.pem",
  }

  apache::directive {"dashboard-local":
    ensure    => present,
    vhost     => "pm.camptocamp.net",
    directive => "
PassengerStatThrottleRate 120
RackAutoDetect On
RailsAutoDetect On

RewriteEngine On
RewriteCond %{HTTPS} ^off$
RewriteCond %{REMOTE_ADDR} !127.0.0.1
RewriteCond %{REMOTE_ADDR} !${ipaddress_eth0}
rewriteRule ^/.* - [F,L]
",
  }

}
