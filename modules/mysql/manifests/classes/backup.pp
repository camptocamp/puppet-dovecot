/*
== Class: mysql::backup

Enable mysql daily backup script.

The script /usr/local/bin/mysql-backup.sh will be run every night. It runs
mysqldump --all-databases. Backups will be stored in /var/backups/mysql.

Attributes:
- $mysqldump_retention: defines if backup rotate on a weekly, monthly or yearly
  basis. Accepted values: "week", "month", "year". Defaults to "week".

*/
class mysql::backup {

  if $mysqldump_retention {} else { $mysqldump_retention = "week" }

  file { "/var/backups/mysql":
    ensure  => directory,
    owner   => "root",
    group   => "root",
    mode    => 750,
  }

  file { "/usr/local/bin/mysql-backup.sh":
    ensure => present,
    source => "puppet:///mysql/mysql-backup.sh",
    owner => "root",
    group => "root",
    mode  => 555,
  }

  cron { "mysql-backup":
    command => "/usr/local/bin/mysql-backup.sh ${mysqldump_retention}",
    user    => "root",
    hour    => 2,
    minute  => 0,
    require => [File["/var/backups/mysql"], File["/usr/local/bin/mysql-backup.sh"]],
  }

}
