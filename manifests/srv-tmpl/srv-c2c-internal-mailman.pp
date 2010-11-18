class srv-c2c-internal-mailman {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "mailman interne"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-internal-mailman
}
