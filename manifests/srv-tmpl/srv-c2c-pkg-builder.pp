class srv-c2c-pkg-builder {
  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "srv-c2c-pkg-builder"

  ### OS #########################################
  include os-base
  #include os-server FIXME: not ready for squeeze !

  ### MW #########################################

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-pkg-builder
}
