class mw-bazaar-client {
  case $operatingsystem {
    Ubuntu: {
      package{ ["bzr", "bzrtools"]: ensure => latest }
    }
    Debian: {
      os::backported_package {"bzr": ensure => latest }
    }
  }
}
