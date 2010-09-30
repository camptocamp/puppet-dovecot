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
