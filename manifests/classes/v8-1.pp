class postgresql::v8-1 inherits postgresql::base {

  case $lsbdistcodename {
    etch: {
      package { "postgresql-8.1":
        ensure => installed
      }
      
      service { "postgresql-8.1":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.1"]
      }
    }
    default: {
      fail "postgresql version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
