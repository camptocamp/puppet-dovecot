class bazaar::client {
  case $lsbdistcodename {
    hardy,
    intrepid,
    lucid,
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
