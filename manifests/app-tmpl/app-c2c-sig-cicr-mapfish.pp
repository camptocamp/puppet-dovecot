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
    "alex on admin":    sadb_user => "alex",    user => "admin", require => User["admin"];
    "jeichar on admin": sadb_user => "jeichar", user => "admin", require => User["admin"];
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

  apache::directive {"ushahidi":
    vhost     => "cicr-mapfish",
    directive => "
Alias /ushahidi /var/www/cicr-mapfish/htdocs/ushahidi
<Directory /var/www/cicr-mapfish/htdocs/ushahidi>
        Order allow,deny
        Allow from all
</Directory>
",
  }

  package {[
    "php5-mcrypt",
    "git-core",
    ]:
    ensure => present,
  }

  vcsrepo {"/var/www/cicr-mapfish/htdocs/ushahidi":
    ensure   => present,
    source   => "git://github.com/ushahidi/Ushahidi_Web.git",
    provider => "git",
    require  => Package["git-core"],
    revision => "27e186992fac",
  }

  file {[
      "/var/www/cicr-mapfish/htdocs/ushahidi/application/config",
      "/var/www/cicr-mapfish/htdocs/ushahidi/themes",
      "/var/www/cicr-mapfish/htdocs/ushahidi/media",
    ]:
    ensure => directory,
    require => Vcsrepo["/var/www/cicr-mapfish/htdocs/ushahidi"],
    owner   => admin,
    group   => admin,
    recurse => true,
  }

  file {"/var/www/cicr-mapfish/htdocs/ushahidi/.htaccess":
    ensure => file,
    require => Vcsrepo["/var/www/cicr-mapfish/htdocs/ushahidi"],
    owner   => admin,
    group   => admin,
  }

  file {"/var/www/cicr-mapfish/htdocs/ushahidi/application/cache/":
    ensure => directory,
    require => Vcsrepo["/var/www/cicr-mapfish/htdocs/ushahidi"],
    owner   => www-data,
    group   => admin,
    recurse => false,
    mode    => 2770,
  }

  include mysql::server

  mysql::database {"icrc-ushaidi":
    ensure => present,
  }

  mysql::rights {"icrc-ushaidi on icrc-ushaidi":
    ensure => present,
    database => "icrc-ushaidi",
    user => "icrc-ushaidi",
    password => "yapugaeCh8",
    require => Mysql::Database["icrc-ushaidi"],
  }
}
