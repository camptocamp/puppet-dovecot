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

  apache::auth::htpasswd {"rt-19381":
    ensure        => present,
    username      => "cicr",
    clearPassword => "25dunant",
    vhost         => "cicr-mapfish",
  }
  apache::auth::basic::file::user {"auth on cicr":
    vhost => "cicr-mapfish",
    ensure => absent,
  }
  apache::directive {"cicr-auth":
    vhost     => "cicr-mapfish",
    directive => '
<LocationMatch ^/(?!geoserver.*).*$>
  AuthName "Private area"
  AuthType Basic
  AuthBasicProvider file
  AuthUserFile /var/www/cicr-mapfish/private/htpasswd
  Require valid-user
</LocationMatch>
',
  }

}
