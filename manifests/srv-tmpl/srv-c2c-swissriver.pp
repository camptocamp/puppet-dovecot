class srv-c2c-swissriver {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "swissriver"
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"
  $sudo_tomcat_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache-ssl
  include mw-sig
  include mw-postgresql-8-3
  include mw-postgis-8-3

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-swissriver
}
