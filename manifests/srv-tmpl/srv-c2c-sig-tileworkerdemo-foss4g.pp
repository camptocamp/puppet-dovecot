# Server type used on node c2cpc46
#
# This server type and node c2cpc46 can be removed after foss4g 2010.
#

class srv-c2c-sig-tileworkerdemo-foss4g {

  ### Global attributes ##########################
  $server_group = "demo" #(one of dev, demo or prod)
  $ps1label = "tileworker-interface-demo"

  $wwwroot = "/var/www/"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-sig-tileworkerdemo-foss4g

}
