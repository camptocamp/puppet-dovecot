import "classes/*.pp"

class mapserver {
  case $operatingsystem {
    Debian:  { include mapserver::debian}
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

  case $epsg_file {
    "tuned","minimal": {
      include mapserver::epsg::minimal
    }
    default: {
      include mapserver::epsg
    }
  }

}
