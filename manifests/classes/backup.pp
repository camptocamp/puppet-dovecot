class postgresql::backup {

  file { "/var/backups/pgsql":
    ensure  => directory,
    owner   => "postgres",
    group   => "postgres",
    mode    => 755,
    require => [Package["postgresql"], User["postgres"]],
  }

  file { "/usr/local/bin/pgsql-backup.sh":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 755,
    source  => "puppet:///postgresql/usr/local/bin/pgsql-backup.sh",
    require => File["/var/backups/pgsql"],
  }

  cron { "pgsql-backup":
    command => "/usr/local/bin/pgsql-backup.sh",
    user    => "postgres",
    hour    => 2,
    minute  => 0,
    require => [User["postgres"], File["/usr/local/bin/pgsql-backup.sh"]],
  }

}
