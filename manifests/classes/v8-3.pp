class postgresql::v8-3 inherits postgresql::base {

  case $lsbdistcodename {
    "etch" : {
      os::backported_package { ["postgresql-8.3", "postgresql-common", "postgresql-client-common"]:
        ensure => present,
      }
    
      service { "postgresql-8.3":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.3"],
      }
    }
    "lenny", "hardy": {
      package { "postgresql-8.3":
        ensure => installed
      }

      service { "postgresql-8.3":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.3"],
      }
    }
    default: {
      fail "postgresql version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
