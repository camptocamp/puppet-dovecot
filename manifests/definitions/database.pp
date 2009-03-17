define mysql::database($ensure) {

  mysql_database { $name:
    ensure => $ensure,
    require => File["/root/.my.cnf"],
  }

}
