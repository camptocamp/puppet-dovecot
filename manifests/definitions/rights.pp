define mysql::rights($database, $user, $password, $host="localhost", $ensure="present") {

  if $mysql_exists == "true" and $ensure == "present" {
    mysql_user { "${user}@${host}":
      password_hash => mysql_password($password),
      require => File["/root/.my.cnf"],
    }

    mysql_grant { "${user}@${host}/${database}":
      privileges => "all",
      require => File["/root/.my.cnf"],
    }
  }

}
