node 'c2cpc21.camptocamp.com' {
  $aa = server_alias_from_domain($fqdn)
  notify {"The value is: ${aa}": }
  include srv-c2c-sig-blonay-cartoriviera
}
