class wrk-avocatsch {

  ### Global attributes ##########################
  $ps1label = "workstation"

  ### OS #########################################
  include os-base

  ### MW #########################################
  include apt::unattended-upgrade::automatic

  ### APP (generic) ##############################
  include app-workstation-tuning
  include app-avocatsch-workstation-packages
  include app-avocatsch-workstation

}
