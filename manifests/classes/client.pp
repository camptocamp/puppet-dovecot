class bazaar::client {
  case $lsbdistcodename {
    hardy,
    intrepid,
    lenny: {
      package{["bzr", "bzrtools"]:
        ensure => installed,
      }
    }

    etch: {
      os::backported_package{"bzr":
        ensure => present,
      }

      os::backported_package{"bzrtools":
        ensure  => present,
        #require => Package["bzr"],
      }
    }

    default: {
      notice "Unknown bzr package for $lsbdistcodename"
    }
  }

  package{"python-paramiko":
    ensure => present,
  }
}
