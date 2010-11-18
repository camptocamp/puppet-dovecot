class srv-c2c-pnv-refonte {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "pnv refonte"
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"
  $sudo_tomcat_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-sig
  include mw-apache
  include mw-postgresql-8-3
  include mw-postgis-8-3

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-pnv-refonte
}
