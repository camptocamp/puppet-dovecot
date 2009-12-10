class postgresql::base {

  package {"libpq-dev":
    ensure => installed
  }

  user { "postgres":
    ensure  => present,
    require => Package["postgresql"],
  }

  file { "/var/lib/postgresql":
    ensure  => directory,
    owner   => "postgres",
    group   => "postgres",
    mode    => 755,
    require => [Package["postgresql"], User["postgres"]],
  }

}
