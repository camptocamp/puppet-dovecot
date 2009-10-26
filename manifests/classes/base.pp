class mapfish::base {

  case $lsbdistcodename {
    'etch' : {
      os::backported_package {"libapache2-mod-wsgi":
        ensure => present,
      }

      package{"maven2":
        ensure  => present,
        require => Os::Backported_package["sun-java6-jdk"],
      }
    }
    'lenny' : {
      package {"libapache2-mod-wsgi":
        ensure => present,
      }

      package {"maven2":
        ensure  => present,
        require => Package["sun-java6-jdk"],
      }
    }
  }

  apache::module{ "headers":
    ensure  => present,
  }

  file {"/var/sig":
    ensure => directory,
    owner => www-data,
    group => www-data,
    require => Apache::Module['headers'],
  }

}
