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

      package {"python-virtualenv":
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

}
