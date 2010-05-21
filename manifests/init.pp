import "classes/*.pp"
import "definitions/*.pp"
  
class postgresql {
  case $operatingsystem {
    Debian: { 
      case $lsbdistcodename {
        etch :   { include postgresql::debian::v8-3 }
        lenny :  { include postgresql::debian::v8-3 }
        default: { fail "postgresql not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    } 
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}

class postgresql::v8-3 {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        etch :   { include postgresql::debian::v8-3 }
        lenny :  { include postgresql::debian::v8-3 }
        default: { fail "postgresql 8.3 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}

class postgresql::v8-4 {
  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        lenny :  { include postgresql::debian::v8-4 }
        default: { fail "postgresql 8.4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
