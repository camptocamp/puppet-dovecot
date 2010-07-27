# Server type used on node c2cpc20 (www.camptocamp.com)
#

class srv-c2c-nagios {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "new nagios"

  $wwwroot = "/var/www/"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-nagios

}
