define mysql::database($ensure) {
  case $ensure {
    present:{
      exec {"Create database ${name}":
        command => "mysqladmin create ${name}",
        unless  => "mysql -e '' ${name}",
        require => Exec["Set MySQL server root password"],
      }
    }
   
    absent:{
      exec {"Drop database ${name}":
        command => "mysqladmin drop ${name}",
        onlyif  => "mysql -e '' ${name}",
        require => Exec["Set MySQL server root password"],
      }
    }
  }
}
