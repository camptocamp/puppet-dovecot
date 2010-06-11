# Requires:
#

class os-base {
  include os
  include ssh
  include apt
  include augeas
  include c2c::sysadmin-in-charge-new
  include c2c::skel
  include sudo::base
  include puppet::client

  apt::sources_list {"puppet-0.25":
    ensure => present,
    content => "# file managed by puppet
deb http://dev.camptocamp.com/packages ${lsbdistcodename} puppet-0.25 
deb-src http://dev.camptocamp.com/packages ${lsbdistcodename} puppet-0.25
",
  }

  apt::preferences {["augeas-lenses","augeas-tools", "libaugeas0"]:
    ensure => present,
    pin => "version ${augeas_version}",
    priority => 1100,
  }

  apt::preferences {"facter":
    ensure => present,
    pin => "version 1.5.7-1~c2c*",
    priority => 1100,
  }

  package {["puppet-common","vim-puppet", "puppet-el"]:
    ensure => present,
  }

  apt::preferences {["puppet", "puppet-common","vim-puppet", "puppet-el"]:
    ensure => present,
    pin => "version 0.25.4-2~c2c*",
    priority => 1100,
  }

  augeas {"sshd/AuthorizedKeysFile":
    context => "/files/etc/ssh/sshd_config/",
    changes => "set AuthorizedKeysFile %h/.ssh/authorized_keys",
    notify => Service["ssh"],
  }

  file {"/etc/ssh/authorized_keys":
    ensure => absent,
    purge => true,
    force => true,
  }

  case $lsbdistcodename {
    lenny,lucid : { include apt::unattended-upgrade::automatic }
    default :     { include apt::unattended-upgrade }
  }

}

