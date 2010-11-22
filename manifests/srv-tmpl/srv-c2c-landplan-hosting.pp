class srv-c2c-landplan-hosting {
  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "landplan_hosting"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include generic-tmpl::mw-postgresql-8-3
  include generic-tmpl::mw-postgis-8-3
  include mw-apache
  include generic-tmpl::mw-tomcat
#
#  ### APP (generic) ##############################
  include app-c2c-sig
#
#  ### APP (specific to this server) ##############
  include app-c2c-landplan-hosting
}
