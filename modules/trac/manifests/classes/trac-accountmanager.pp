
class trac::accountmanager {

  case $lsbdistcodename {
    lenny: {
      package {"trac-accountmanager":
        ensure => present;
      }
    }
    default: {
      fail "trac-accountmanager not available for this distribution"
    }
  }
}
