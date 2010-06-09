node 'c2cpc9.camptocamp.com' {
  $root_mail_recipient = "c2c.sysadmin@camptocamp.com"
  $postfix_relayhost = "mail.camptocamp.com"
  include postfix::satellite
  include srv-c2c-puppetmaster
}
