# Standard OpenERP installation
#
# Requires: mw-postgresql

class mw-openerp {
  include postgresql::backup
  include openerp::server::multiinstance
  include c2c::openteam-in-charge

  include c2c::sudo::workaround
  # we have to use backported bzr package - include this template
  # instead of bazaar::client
  include mw-bazaar-client
  
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
  
  package { [ "python-excelerator",
              "python-mako",
            ]:
    ensure => present,
  }

  common::concatfilepart {"openerp_su_postgres":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "%openerp ALL=(ALL) NOPASSWD: /bin/su - postgres, /bin/su postgres\n",
  }

  common::concatfilepart {"openerp manage opernerp services":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "%openerp ALL=(ALL) NOPASSWD: /etc/init.d/openerp-multi-instances\n%openerp ALL=(ALL) NOPASSWD: /etc/init.d/openerp*\n",
  }

  file {"/var/run/openerp":
    ensure  => directory,
    owner   => openerp,
    group   => openerp,
    mode    => 0755,
    require => User["openerp"],
  }
}
