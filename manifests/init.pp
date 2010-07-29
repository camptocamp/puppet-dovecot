/*

== Class: python

Ensures the default version of python is installed using your system's package
management tool.

Usage:
  include python

*/
class python {

  package { ["python", "python-setuptools"]:
    ensure => present,
  }
}

/*

== Class: python::dev

Ensures python's C header files are installed on your system. This will allow
you to use "easy_install" to install modules built in C.

Usage:
  include python::dev

*/
class python::dev {

  include python

  package { "python-dev":
    ensure => present,
    name   => $operatingsystem ? {
      Debian => "python-dev",
      RedHat => "python-devel",
    },
  }

  package {"ipython":
    ensure => present,
  }
}

/*
== Class: python::virtualenv

Install virtualenv, to help people create python-"chroots" with packages not
necessarily available in the distribution.

Usage:
  include python::virtualenv

*/
class python::virtualenv {

  include python::dev

  package { "python-virtualenv":
    ensure => present,
  }
}

/*

== Class: python::mod_python

Installs and enables mod_python for the apache web server.

Requires:
  Class["apache"]

Usage:
  include apache
  include python::mod_python

*/
class python::mod_python {

  include python

  package { "mod_python":
    ensure => present,
    name   => $operatingsystem ? {
      Debian  => "libapache2-mod-python",
      default => "mod_python",
    }
  }

  apache::module { "python":
    ensure  => present,
    require => Package["mod_python"],
  }

  case $operatingsystem {

    RedHat: {
      file { "/etc/httpd/conf.d/python.conf":
        ensure => absent,
        before => Apache::Module["python"],
      }
      file { "/etc/httpd/mods-available/python.load":
        ensure => present,
        source => "puppet:///python/httpd/python.load",
        before => Apache::Module["python"],
      }

    }
  }
}

