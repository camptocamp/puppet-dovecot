class postgresql::base {

  package {"libpq-dev":
    ensure => installed
  }

  user { "postgres":
    ensure  => present,
    require => Package["postgresql"],
  }

  file { ["/var/backups/pgsql", "/var/lib/postgresql"]:
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

  exec {"force UTF8 as default encoding" : 
    command   => "echo \"UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';drop database template1;create database template1 with template = template0 encoding = 'UTF8';UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';\" |psql",
    unless    => "psql -l |grep template1 |grep -q UTF8",
    user      => postgres,
    require   => [Package["postgresql"], User["postgres"]],
  }

}
