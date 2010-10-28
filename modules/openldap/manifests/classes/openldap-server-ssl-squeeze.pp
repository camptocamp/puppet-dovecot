class openldap::server::ssl::squeeze inherits openldap::server::squeeze {
  file {"/etc/ldap/ssl":
    ensure => directory,
    owner  => openldap,
    group  => openldap,
    mode   => 0755,
    require => Package["slapd"],
  }
}
