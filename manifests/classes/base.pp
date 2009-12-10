class mapfish::base {

  case $lsbdistcodename {
    'etch' : {
      os::backported_package {"libapache2-mod-wsgi":
        ensure => present,
      }
    }
    'lenny' : {
      package {"libapache2-mod-wsgi":
        ensure => present,
      }

      package {"python-virtualenv":
        ensure => present,
      }
    }
  }

  apache::module{ "headers":
    ensure  => present,
  }

}
