class wrk-c2c {

  ### Global attributes ##########################
  $ps1label = "wrk-c2c"

  ### OS #########################################
  include os-base

  ### MW #########################################
  include mw-java-v6
  include bazaar::client
  include apt::unattended-upgrade::automatic

  ### APP (generic) ##############################
  include app-workstation-tuning
  include app-c2c-workstation-packages
  include app-c2c-workstation
  include app-c2c-workstation-vpn
  include app-c2c-workstations-vmware
  include app-c2c-workstation-openerp
  include app-c2c-workstation-vpn-swisstopo
  include app-c2c-workstation-printers
  c2c::workstation::sadb::user{$c2c_workstation_users:}

}
