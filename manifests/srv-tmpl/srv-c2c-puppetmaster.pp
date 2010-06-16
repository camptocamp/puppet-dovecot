# Server type used on node pm.camptocamp.net
#

class srv-c2c-puppetmaster {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "new puppetmaster"
  $puppetmaster_confdir = "/srv/puppetmaster/prod/"
  $puppetmaster_ssldir = "/var/lib/puppet/ssl"
  $root_mail_recipient = "c2c.sysadmin@camptocamp.com"
  $postfix_relayhost = "mail.camptocamp.com"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache-ssl
  include postfix::satellite

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-puppetmaster

}
