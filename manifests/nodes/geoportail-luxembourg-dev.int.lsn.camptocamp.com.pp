node "geoportail-luxembourg-dev.int.lsn.camptocamp.com" {
  include srv-c2c-sig-demo
  package {"slapd":
    ensure => present,
  }
}
