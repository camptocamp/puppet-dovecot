import "classes/*.pp"

class mapserver {
  case $operatingsystem {
    Debian:  { include mapserver::debian}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
