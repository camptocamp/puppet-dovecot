class app-c2c-search {
  include mw-apache
  apache::vhost {$fqdn:
    ensure => present,
    aliases => ["search", "search.camptocamp.com"],
  }
  file {"/etc/ssh/authorized_keys/search/keys":
    ensure => absent,
  }
  file {"/etc/ssh/authorized_keys/search":
    ensure  => absent,
    purge   => true,
    recurse => true,
    force   => true,
  }
}
