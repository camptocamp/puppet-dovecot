# Server type used on node c2cpc9.camptocamp.com
#

class srv-c2c-puppetmaster {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "new puppetmaster"
  $puppetmaster_confdir = "/srv/puppetmaster/prod/"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache-ssl

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-puppetmaster

}
