define mysql::rights($database, $user, $password, $host="localhost", $ensure="present") {

  if $mysql_exists == "true" {
    mysql_user { "${user}@${host}":
      ensure => $ensure,
      password_hash => mysql_password($password),
      require => File["/root/.my.cnf"],
    }

    mysql_grant { "${user}@${host}/${database}":
      ensure => $ensure,
      privileges => "all",
      require => File["/root/.my.cnf"],
    }
  }

}
