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
    enable => true,
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

  # lens included upstream since augeas 0.7.4
  if versioncmp($augeasversion, '0.7.3') < 0 { $lens = present }
  else { $lens = absent }

  file { "/usr/share/augeas/lenses/contrib/pg_hba.aug":
    ensure => $lens,
    mode   => 0644,
    owner  => "root",
    source => "puppet:///postgresql/pg_hba.aug",
  }

}
