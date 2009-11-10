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
  
      # [workaround]
      # by default pg_createcluster encoding derived from locale
      # but it do does not work by installing postgresql via puppet ?!
      exec {"force UTF8 as default encoding" : 
        command   => "echo \"UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';drop database template1;create database template1 with template = template0 encoding = 'UTF8';UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';\" |psql",
        unless    => "psql -l |grep template1 |grep -q UTF8",
        user      => postgres,
        require   => Service["postgresql-8.3"],
      }

    }
    default: {
      fail "postgresql version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }

}
