class mysql::slave inherits mysql::server {

  Augeas["my.cnf/replication"] {
    changes => [
      "set log-bin mysql-bin",
      "set relay-log /var/lib/mysql/mysql-relay-bin",
      "set relay-log-index /var/lib/mysql/mysql-relay-bin.index",
      "set relay-log-info-file /var/lib/mysql/relay-log.info",
      "set server-id ${mysql_serverid}",
      "set master-host ${mysql_masterhost}",
      "set master-user ${mysql_masteruser}",
      "set master-password ${mysql_masterpw}",
      "set report-host ${hostname}"
    ],
  }

  Cron["mysql-backup"] {
    ensure => absent
  }

  File["/usr/local/bin/mysql-backup.sh"] {
    ensure => "absent"
  }
}

