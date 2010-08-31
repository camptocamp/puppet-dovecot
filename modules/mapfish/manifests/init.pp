import "classes/*.pp"

/*

== Class: mapfish

Install basis for a mapfish application

*/
class mapfish {
  case $operatingsystem {
    Debian:  { include mapfish::debian}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
