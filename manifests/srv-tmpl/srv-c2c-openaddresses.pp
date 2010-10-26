class srv-c2c-openaddresses {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = 'www.openaddresses.org'
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"
  $sudo_tomcat_admin_user = "deploy, %admin"

  $wwwroot = "/var/www/"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include mw-java-v6
  include mw-postgresql-8-4
  include mw-postgis-8-4
  include mw-sig

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-openaddresses
}
