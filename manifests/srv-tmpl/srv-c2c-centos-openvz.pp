class srv-c2c-centos-openvz {
  ### Global attributes ##########################
  $ps1label = "openvz HN"

  ### OS #########################################
  include os-base
  include os-openvz
  include os-openvz-centos
  
  ### MW #########################################
}
