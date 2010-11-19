class app-c2c-landplan-hosting {
  user {"admin":
    ensure     => present,
    managehome => true,
    groups     => ["www-data","sigdev"],
    shell      => "/bin/bash",
    require    => Group["sigdev"],
  }

  group {"admin":
    ensure  => present,
    require => User["admin"],
  }

  c2c::ssh_authorized_key {
    "ochriste": require => User["admin"], sadb_user => "ochriste", user => "admin";
    "ebelo":    require => User["admin"], sadb_user => "ebelo",    user => "admin";
    "alex":     require => User["admin"], sadb_user => "alex",     user => "admin";
    "akraenchi":require => User["admin"], sadb_user => "akraenchi",user => "admin";
    "aeisenhut":require => User["admin"], sadb_user => "aeisenhut",user => "admin";
    "msteiner": require => User["admin"], sadb_user => "msteiner", user => "admin";
  }

  apache::vhost {"landplan":
    ensure  => present,
    group   => "admin",
    mode    => 2775,
    require => User["admin"],
    aliases => $fqdn,
  }
}

