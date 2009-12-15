class mysql::master inherits mysql::server {

  Augeas["my.cnf/replication"] {
    changes => [
      "set log-bin mysql-bin",
      "set server-id ${mysql_serverid}",
      "set expire_logs_days 7",
      "set max_binlog_size 100M"
    ],
  }

}
