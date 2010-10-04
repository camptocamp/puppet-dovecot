class srv-c2c-centos-openvz {
  ### Global attributes ##########################
  $ps1label = "openvz HN"
  $server_group = "prod"

  ### OS #########################################
  include os-base
  include os-monitoring
  include os-openvz
  include os-openvz-centos
  
  ### MW #########################################

  include app-c2c-centos-openvz
}
