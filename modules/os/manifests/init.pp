import "classes/*.pp"
import "definitions/*.pp"

class os {

  file { "/tmp":
    ensure => directory,
    mode   => 1777,
    owner  => root,
    group  => root
  }

  case $operatingsystem {
    debian: {
      case $lsbdistcodename {
        lenny,
        etch,
        sarge: {
          include "os::debian-${lsbdistcodename}"
          include os::debian::backports
        }

        default: {
          fail "Unsupported Debian version '${lsbdistcodename}' in 'os' module"
        }
      }
    }

    ubuntu: {
      case $lsbdistcodename {
        dapper,
        edgy,
        feisty,
        gutsy,
        hardy,
        intrepid,
        jaunty,
        lucid: {
          include "os::ubuntu-${lsbdistcodename}"
          include os::debian::backports
        }

        default: {
          fail "Unsupported Ubuntu version ${lsbdistcodename} in 'os' module"
        }
      }
    }

    CentOS: {
      include os::centos
    }
    default: {
      fail "Unsupported OS ${operatingsystem} in 'os' module"
    }
  }
}
