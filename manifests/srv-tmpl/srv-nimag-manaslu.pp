# Server type used on node srv-nimag-manaslu
#

class srv-nimag-manaslu {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $is_external = true
  $ps1label = "external backups"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################


  ### APP (generic) ##############################
  include app-nimag-manaslu
}
