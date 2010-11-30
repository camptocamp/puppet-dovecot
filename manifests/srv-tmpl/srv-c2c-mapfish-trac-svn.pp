# Server type used on c2cpc74

class srv-c2c-mapfish-trac-svn {

  ### Global attributes ##########################
  $server_group = "prod"
  $sudo_apache_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache-ssl

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-mapfish-trac

}
