# Server type used on node c2cpc31
#

class srv-c2c-mailserver {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "mail server"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############

}
