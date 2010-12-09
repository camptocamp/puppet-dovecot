class srv-c2c-bazaar {
  ### Global attributes ##########################
  $server_group = "prod"
  $sudo_apache_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache-ssl

  ### APP (specific to this server) ##############
  include app-c2c-bazaar
}
