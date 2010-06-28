class app-c2c-sig-blonay-cartoriviera {
  
  apache::vhost {"blonay-cartoriviera":
    ensure  => present,
    group   => sigdev,
    mode    => 2775,
    aliases => [$fqdn, server_alias_from_domain($fqdn)],
  }

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => sigdev,
  } 

  user {"admin":
    ensure     => present,
    managehome => true,
    home       => "/home/admin",
    shell      => "/bin/bash",
  }

  c2c::ssh_authorized_key{
    "alex on admin": sadb_user => "alex", user => "admin", require => User["admin"];
  }
}
