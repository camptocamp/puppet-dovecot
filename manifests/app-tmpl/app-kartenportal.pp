class app-kartenportal {

  user {"admin":
    ensure     => present,
    shell      => "/bin/bash",
    home       => "/home/admin",
    managehome => true,
  }

  lighttpd::vhost{ $fqdn:
    ensure  => present,
    aliases => ["kartenportal.mapranksearch.com"],
    group   => admin,
    require => User["admin"],
  }
}
