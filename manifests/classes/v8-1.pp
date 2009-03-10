class postgresql::v8-1 inherits postgresql::base {

  case $lsbdistcodename {
    etch: {
      package {"postgresql-8.1":
        ensure => installed,
        alias  => "postgresql",
      }

      package {"postgresql-common":
        ensure => installed,
      }
      
      service { "postgresql-8.1":
        ensure    => running,
        hasstatus => true,
        require   => Package["postgresql-8.1"],
        alias     => "postgresql",
      }
    }
    default: {
      fail "postgresql version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
