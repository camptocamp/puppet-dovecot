class bazaar::client {
  case $lsbdistcodename {
    lucid,
    lenny,
    squeeze: {
      package{["bzr", "bzrtools"]:
        ensure => installed,
      }
    }
    default: {
      notice "Unknown bzr package for $lsbdistcodename"
    }
  }
}
