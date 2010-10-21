class srv-c2c-pkg-repository {
  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "srv-c2c-pkg-repository"

  ### OS #########################################
  include os-base
  #include os-server FIXME: not ready for squeeze !

  ### MW #########################################
  include mw-apache

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-pkg-repository
}
