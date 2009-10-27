class postgresql::v8-3 inherits postgresql::base {

  case $lsbdistcodename {
    
    "etch" : {
      os::backported_package {"postgresql-8.3":
        ensure => present,
        alias  => "postgresql",
      }

      os::backported_package {"postgresql-common":
        ensure => present,
      }
       
      os::backported_package {"postgresql-client-common":
        ensure => present,
      }
   
      service { "postgresql-8.3":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.3"],
        alias     => "postgresql",
      }
    }
  
    "lenny", "hardy": {
      package { "postgresql-8.3":
        ensure  => installed,
        alias   => "postgresql",
      }

      service { "postgresql-8.3":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.3"],
        alias     => "postgresql",
      }
    }
    default: {
      fail "postgresql version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
