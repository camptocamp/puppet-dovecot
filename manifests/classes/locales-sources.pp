/*

*/
class locales::sources {
  case $operatingsystem {
    /Debian|Ubuntu/: { include locales::debian::source}
    default: { fail "$operatingsystem not yet supported" }
  }
}
