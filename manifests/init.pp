import "classes/*.pp"
import "definitions/*.pp"
  
class postgresql {
  case $operatingsystem {
    Debian:  { 
      case $lsbdistcodename {
        etch :  { include postgresql::debian::v8-3 }
        lenny : { include postgresql::debian::v8-3 }
        default: { fail "postgresql not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    } 
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }
}
