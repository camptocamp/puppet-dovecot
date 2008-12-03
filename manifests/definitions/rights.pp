define mysql::rights($database, $user, $password, $ensure=true) {
  case $ensure {
    present:{
      exec {"Set rigths for db ${database}":
        command => "mysql -e \"GRANT ALL PRIVILEGES on ${database}.* TO ${user}@localhost IDENTIFIED BY '${password}';\"",
        unless  => "mysql --database=${database} --user=${user} --password=${password} -A -e 'exit'",
        require => Exec["Set MySQL server root password"],
      }
    }
   
    absent:{
      exec {"unsert rights for db ${database}":
        command => "mysql -e \"REVOKE ALL PRIVILEGES on ${database}.* FROM ${user}@localhost;\"",
        onlyif  => "mysql --database=${database} --user=${user} --password=${password} -A -e 'exit'",
        require => Exec["Set MySQL server root password"],
      }
    }
  }
}
