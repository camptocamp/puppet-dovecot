import "classes/*.pp"

class java {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        etch,lenny,squeeze : { include java::v6 }
        default: { fail "java::v6 not available for ${operatingsystem}/${lsbdistcodename}" }
      }
    }
    Ubuntu: { 
      case $lsbdistcodename {
        hardy,intrepid,jaunty,lucid : { include java::v6 }
        default: { fail "java::v6 not available for ${operatingsystem}/${lsbdistcodename}" }
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

}

