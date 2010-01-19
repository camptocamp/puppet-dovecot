class postgresql::backup {

  if ( ! $postgresql_backupdir ) {
    $postgresql_backupdir = "/var/backups/pgsql"
  }

  file {$postgresql_backupdir:
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
    content => template("postgresql/pgsql-backup.sh.erb"),
    require => File[$postgresql_backupdir],
  }

  cron { "pgsql-backup":
    command => "/usr/local/bin/pgsql-backup.sh",
    user    => "postgres",
    hour    => 2,
    minute  => 0,
    require => [User["postgres"], File["/usr/local/bin/pgsql-backup.sh"]],
  }

}
