class openldap::server::squeeze inherits openldap::base {
  file {"/var/cache/debconf/slapd.preseed":
    ensure  => present,
    mode    => 0644,
    owner   => root,
    group   => root,
    content => template("openldap/slapd-2.x.preseed.erb"),
  }

  package {"slapd":
    ensure       => present,
    require      => File["/var/cache/debconf/slapd.preseed"],
    responsefile => "/var/cache/debconf/slapd.preseed",
  }
}
