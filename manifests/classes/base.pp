class postgresql::base {

  package { ["libpq-dev", "phppgadmin"]:
    ensure => installed
  }

  group { "postgres":
    ensure => present,
  }

  user { "postgres":
    ensure  => present,
    gid     => "postgres",
    groups  => "ssl-cert",
    comment => "PostgreSQL administrator,,,",
    home    => "/var/lib/postgresql",
    shell   => "/bin/bash"
  }

  file { "/var/backups/pgsql":
    ensure  => directory,
    owner   => "postgres",
    group   => "postgres",
    mode    => 755,
    require => [User["postgres"], Group["postgres"]],
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
    require => File["/usr/local/bin/pgsql-backup.sh"],
  }

}
