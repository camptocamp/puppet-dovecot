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
    debian,Ubuntu: {

      case $lsbdistcodename {
        lenny: {
          include os::debian-lenny
          include os::debian::backports
        }

        etch: {
          include os::debian-etch
          include os::debian::backports
        }

        sarge: {
          include os::debian-sarge
          include os::debian::backports
        }
        
        gutsy: {
          include os::ubuntu-gutsy
          include os::debian::backports
        }

        hardy: {
          include os::ubuntu-hardy
          include os::debian::backports
        }

        default: {
          fail "Unsupported version '${lsbdistcodename}' for Operating System ${operatingsystem}"
        }
      }
    }
    default: {
      fail "Unsupported operatingsystem ${operatingsystem} in 'os' module"
    }
  }
}
