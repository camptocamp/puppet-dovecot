class app-c2c-unhcr-dev {

  package {["libapache2-mod-jk", "python-httplib2"]:
    ensure => present,
  }

  # openldap part
  package {["ldap-utils", "libldap-2.4-2"]:
    ensure => present,
  }

  augeas{"ldap.conf":
    context => "/files/etc/ldap/ldap.conf",
    changes => [
      "set URI ldaps://193.134.241.62",
      "set BASE cn=geoportal,ou=Agents,dc=unhcr,dc=org",
      "set ssl on",
      "set TLS_CACERT '/etc/ldap/ssl/client.pem'",
    ],
    require => Package["ldap-utils"],
  }

  file {"/etc/ldap/ssl":
    ensure  => directory,
    mode    => 0644,
    owner   => root,
    group   => root,
    require => Package["ldap-utils"],
  }
  file {"/etc/ldap/ssl/client.pem":
    ensure  => present,
    mode    => 0644,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/c2c/ssl/unhcr-ldap-client.pem",
    require => File["/etc/ldap/ssl"],
  }


  apache::vhost-ssl{"unhcr":
    ensure  => present,
    group   => "sigdev",
    aliases => [$fqdn],
  }

  apache::vhost {"mapfish-local":
    ensure  => present,
    group   => sigdev,
    aliases => ["mapfish-local.camptocamp.net"],
  }

  host {"mapfish-local.camptocamp.com":
    ensure => absent,
    ip     => "127.0.0.1",
  }

  host {"mapfish-local.camptocamp.net":
    ensure => present,
    ip     => "127.0.0.1",
  }

  host {"swigec33.swige.unhcr.org":
    ensure => present,
    ip     => "193.134.241.62",
  }

  tomcat::instance {"geoportal-unhcr":
    ensure => present,
    group  => "sigdev",
  }

  user {"admin":
    ensure      => present,
    managehome  => true,
    groups      => ["sigdev", "www-data"],
    shell       => "/bin/bash",
  }

  c2c::ssh_authorized_key {
    "fredj on admin":        ensure => present, user => admin, require => User["admin"], sadb_user => "fredj";
    "elemoine on admin":     ensure => present, user => admin, require => User["admin"], sadb_user => "elemoine";
    "yves on admin":         ensure => present, user => admin, require => User["admin"], sadb_user => "yves";
    "jeichar on admin":      ensure => present, user => admin, require => User["admin"], sadb_user => "jeichar";
    "pierre on admin":       ensure => present, user => admin, require => User["admin"], sadb_user => "pierre";
    "aabt on admin":         ensure => present, user => admin, require => User["admin"], sadb_user => "aabt";
    "fvanderbiest on admin": ensure => present, user => admin, require => User["admin"], sadb_user => "fvanderbiest";
  }


  user {"elegoupil":
    ensure      => present,
    managehome  => true,
    groups      => ["sigdev", "www-data"],
    shell       => "/bin/bash",
  }

  ssh_authorized_key {"legoupil@unhcr.org":
    ensure  => present,
    user    => "elegoupil",
    require => User["elegoupil"],
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEA1pyVTvB7DFrjuxDLz31v3LdUap/Yr8l5aR3XiKklqZcPPlWnq9TfadXcyI4vrPuk+kdhXjhT4dcWHdokgdQInS4vl7SlHd11Fj3pyMzHRZSXohz3PjUlrV+v1qo/4AlTofJu8chRAEqgLzvkXdUBdBAUbNF91/0C9oCIQCb9DWM=",
  }

  user {"dyotsov":
    ensure      => present,
    managehome  => true,
    groups      => ["sigdev", "www-data"],
    shell       => "/bin/bash",
  }

  ssh_authorized_key {"yotsov@unhcr.org":
    ensure  => present,
    user    => "dyotsov",
    require => User["dyotsov"],
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEAm2Zw9kml56zvTgyq/uB5mjnqoAyXGpgZTta2gJlsVL2sRfX7tHGl1I8KP9BfBeselGQUWcq5/zjfcPqYS6yw2KeHqCWFNeG5n6flisKHnui+kf2Mebo720WD1Vv5ZRD270sGxgdUUYq+X+2zRMYZMCGzN5Qtb94CMm8pYJefRt8=",
  }

}
