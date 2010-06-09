class wrk-c2c {

  ### Global attributes ##########################
  $ps1label = "wrk-c2c"

  ### OS #########################################
  include os-base

  ### MW #########################################
  include mw-java-v6
  include bazaar::client
  include apt::unattended-upgrade::automatic

  ### MW #########################################

  ### APP (generic) ##############################
  include app-workstation-tuning
  include app-c2c-workstation-vpn
  include app-c2c-worstations-vmware

  ### APP (specific ) ############################
  c2c::workstation::sadb::user{$c2c_workstation_users:}

}
