node 'landplan-mapfish-dev.int.lsn.camptocamp.com' {
  $postgresql_version = "8.3"
  $apache_vhost_name = $fqdn
  include srv-c2c-sig-dev
}
