class app-c2c-sig-alpgis-mapfish {

  group {"admin":
    ensure  => present,
    require => User["admin"],
  }
  
  apache::vhost {"alpgis_mapfish":
    ensure  => present,
    group   => admin,
    mode    => 2775,
    aliases => "$fqdn"
  }

  user {"admin":
    ensure     => present,
    managehome => true,
    home       => "/home/admin",
    shell      => "/bin/bash",
    groups     => ["www-data", "sigdev"],
  }

  c2c::ssh_authorized_key{
    "alex on admin"     : sadb_user => "alex",      user => "admin", require => User["admin"];
    "ebelo on admin"    : sadb_user => "ebelo",     user => "admin", require => User["admin"];
    "bquartier on admin": sadb_user => "bquartier", user => "admin", require => User["admin"];
    "elemoine on admin": sadb_user => "elemoine", user => "admin", require => User["admin"];
    "sbrunner on admin": sadb_user => "sbrunner", user => "admin", require => User["admin"];
  }

}
