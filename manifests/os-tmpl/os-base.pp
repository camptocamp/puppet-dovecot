# Requires:
#

class os-base {

  include os
  include ssh
  include augeas
  include subversion
  include c2c::sysadmin-in-charge-new
  include c2c::skel
  include sudo::base
  include puppet::client

  case $operatingsystem {
    /Ubuntu|Debian/: { include os-base-debian }
    /RedHat|CentOS/: { include os-base-centos }
    default: { fail "Nothing configured for \$operatingsystem $operatingsystem" }
  }
}

