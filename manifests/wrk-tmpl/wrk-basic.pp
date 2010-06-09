class wrk-basic {

  ### Global attributes ##########################
  $ps1label = "wrk-basic"

  ### OS #########################################
  include os-base

  ### MW #########################################
  include mw-java-v6
  include bazaar::client
  include apt::unattended-upgrade::automatic

}
