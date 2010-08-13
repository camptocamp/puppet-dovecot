class wrk-sqdf {

  ### Global attributes ##########################
  $ps1label = "workstation"

  ### OS #########################################
  include os-base

  ### MW #########################################
  include apt::unattended-upgrade::automatic

  ### APP (generic) ##############################
  include app-workstation-tuning
  include app-sqdf-workstation-packages
  include app-sqdf-workstation

}
