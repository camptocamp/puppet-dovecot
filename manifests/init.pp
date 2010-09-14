import "./classes/*.pp"
import "./definitions/*.pp"
/*

==Class: locales
wrapper which includes OS class.
By default, it includes locales::${operatingsystem}::all

Usage:

include locales

*/
class locales {
  case $operatingsystem {
    /Debian|Ubuntu/: { include locales::debian::all }
    default: { fail "${operatingsystem} not yet implemented" }
  }
}
