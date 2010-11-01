/*

==Class: postgresql::base

This class is dedicated to the common parts 
shared by the different distributions

*/
class postgresql::base {

  user { "postgres":
    ensure => present,
    require => Package["postgresql"],
  }

  package {"postgresql":
    ensure => present,
    notify => undef,
  }

  service {"postgresql":
    ensure => running,
    hasstatus => true,
    require => Package["postgresql"],
  }

  file { "/var/lib/postgresql":
    ensure => directory,
    owner => "postgres",
    group => "postgres",
    mode => 755,
    require => [Package["postgresql"], User["postgres"]],
  }

}
