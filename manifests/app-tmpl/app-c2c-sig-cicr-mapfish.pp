class app-c2c-sig-cicr-mapfish {
  user {"admin":
    ensure     => present,
    managehome => true,
    home       => "/home/admin",
    shell      => "/bin/bash",
    groups     => ["www-data", "sigdev"],
  }

  group {"admin":
    ensure => present,
    require => User["admin"],
  }
  
  c2c::ssh_authorized_key{
    "alex on admin": sadb_user => "alex", user => "admin", require => User["admin"];
  }

  apache::vhost {"cicr-mapfish":
    ensure => present,
    group  => admin,
    aliases => [$fqdn, "wathab-icrc.camptocamp.net"],
    mode    => 2575,
  }

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => admin,
  }
}
