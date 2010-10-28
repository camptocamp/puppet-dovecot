# Class for specifics for srv-c2c-sadb
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-sadb {

  include postgresql::backup

  apache::vhost {"sadb.camptocamp.com":
    ensure => present,
  }
  apache::module {["proxy", "proxy_http"]:
    ensure => present,
  }
  apache::auth::basic::ldap {"admin":
    ensure        => present,
    vhost         => "sadb.camptocamp.com",
    location      => "/admin/",
    authLDAPUrl   => "ldap://ldap.lsn.camptocamp.com ldap.cby.camptocamp.com/dc=ldap,dc=c2c?uid??(sambaSID=*)",
    authzRequire  => "ldap-user cjeanneret ckaenzig marc mbornoz mremy jbove",
  }

  package {["python-pylons", "python-ldap"]:
    ensure => installed,
  }
  file {"/etc/init.d/pylons":
    ensure => "/var/www/sadb.camptocamp.com/private/sadb/pylons.initd",
  }
  service {"pylons":
    ensure => running,
    require => File["/etc/init.d/pylons"],
  }

  postgresql::user {"sadb":
    ensure => present,
    password => "sadb",
  }
  postgresql::database {"sadb":
    ensure => present,
    owner  => "sadb",
  }  

  # Enable after switch to production
  #c2c::externalbackups {"external backups for $fqdn":
  #  ensure   => present,
  #  includes => "var/backups/pgsql",
  #  fname    => "sadb.int.lsn"
  #}


}
