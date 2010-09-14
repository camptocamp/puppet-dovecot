import "./classes/*.pp"
import "./definitions/*.pp"
/*

==Class: locales
wrapper which includes OS class.

Usage:

include locales

locales::locale {"en_US.UTF-8 UTF-8":
  ensure => present,
}

locales::alias {"en":
  locale => "en_US.UTF-8",
  ensure => present,
}

*/
class locales {
  case $operatingsystem {
    /Debian|Ubuntu/: { include locales::debian }
    default: { fail "${operatingsystem} not yet implemented" }
  }
}
