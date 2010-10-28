class srv-c2c-unhcr-prod {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "unhcr production"
  $sudo_apache_admin_user = "deploy, %admin"
  $sudo_postgresql_admin_user = "deploy, %admin"
  $sudo_tomcat_admin_user = "deploy, %admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-sig
  include mw-apache-ssl
  include mw-tomcat
  include mw-postgis-8-4
  include mw-postgresql-8-4

  ### APP (generic) ##############################
  include app-c2c-sig
  include app-c2c-unhcr

  ### APP (specific to this server) ##############
}
