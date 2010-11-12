# Server type used on node !insert node name here!
#

class srv-geste-gestepc {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $is_external = true

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################


}
