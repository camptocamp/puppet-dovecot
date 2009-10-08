/*

== Class: python

Ensures the default version of python is installed using your system's package
management tool.

Usage:
  include python

*/
class python {

  package { "python":
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

