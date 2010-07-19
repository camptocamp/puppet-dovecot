# Standard OpenERP installation
#
# Requires: mw-postgresql

class mw-openerp {
  include postgresql::backup
  include openerp::server::multiinstance
  include c2c::openteam-in-charge
  include bazaar::client
  
  postgresql::user {"openerp":
    superuser => true,
    ensure => present,
  }
  
  postgresql::user {"openerp_ro":
    ensure => present,
    password => "UK7ooLooze4ahXetofe",
    require  => Postgresql::User["openerp"],
  }
  user {"openerp_ro":
    ensure => present,
  }
  
  package {"python-mako":
    ensure => present,
  }

  common::concatfilepart {"openerp_su_postgres":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "%openerp ALL=(ALL) NOPASSWD: /bin/su - postgres, /bin/su postgres\n",
  }

  file {"/var/run/openerp":
    ensure  => directory,
    owner   => openerp,
    group   => openerp,
    mode    => 0755,
    require => User["openerp"],
  }
}
