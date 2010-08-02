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

  case $operatingsystem {
    Debian: {
      package {"python-mode":
        ensure => present
      }
    }
  }

}
