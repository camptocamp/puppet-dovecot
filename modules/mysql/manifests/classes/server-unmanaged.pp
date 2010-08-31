class mysql::server::unmanaged inherits mysql::server {

  Augeas["my.cnf/performance"] {
    changes => "",
  }

  Augeas["my.cnf/mysqld"] {
    changes => "",
  }

  Augeas["my.cnf/replication"] {
    changes => "",
  }

  Augeas["my.cnf/mysqld_safe"] {
    changes => "",
  }

  Augeas["my.cnf/client"] {
    changes => "",
  }

}
