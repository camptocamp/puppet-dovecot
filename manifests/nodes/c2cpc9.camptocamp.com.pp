node 'c2cpc9.camptocamp.com' {
  $postfix_relayhost = "mail.camptocamp.com"
  include postfix::satellite
  include srv-c2c-puppetmaster
}
