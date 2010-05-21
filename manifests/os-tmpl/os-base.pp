# Base OS class for any type of c2c hosts
#
# Requires:
#

class os-base {
  include os
  include apt
  include c2c::sysadmin-in-charge-new
  include c2c::puppet-client
  include c2c::skel
  #include pam::base

  if $lsbdistcodename == 'lenny' {
    include apt::unattended-upgrade::automatic
  } else {
    include apt::unattended-upgrade
  }

}

