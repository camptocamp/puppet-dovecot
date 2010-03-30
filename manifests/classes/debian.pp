class mapfish::debian {

  case $lsbdistcodename {
    'etch' : {
      os::backported_package {"libapache2-mod-wsgi":
        ensure => present,
      }
    }
    'lenny' : {
      package {[
        "libapache2-mod-wsgi",
        "python-virtualenv",
        "libgeos-dev",
        "naturaldocs",
      ]:
        ensure => present,
      }
    }
  }

  if !defined(Apache::Module["headers"]) {
    apache::module{ "headers":
      ensure  => present,
    }
  }

}
