# Server type used on node srv-nimag-manaslu
#

class srv-c2c-kamet {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "NFS editor"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################


  ### APP (generic) ##############################
  include app-c2c-kamet
  app::c2c::sadb::users{["all c2c users"]: groups => ["sigdev", "www-data"]}
}
