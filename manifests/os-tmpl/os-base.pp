# Base OS class for any type of c2c hosts
#
# Requires:
#

class os-base {
  include os
  include ssh
  include apt
  include c2c::sysadmin-in-charge-new
  include puppet::client
  include c2c::skel
  include sudo::base

  augeas { "sshd/AuthorizedKeysFile":
    context => "/files/etc/ssh/sshd_config/",
    changes => "set AuthorizedKeysFile %h/.ssh/authorized_keys",
    notify => Service["ssh"],
  }

  file {"/etc/ssh/authorized_keys":
    ensure => absent,
    purge => true,
  }

  case $lsbdistcodename {
    lenny,lucid : { include apt::unattended-upgrade::automatic }
    default : { include apt::unattended-upgrade }
  }

}

