class srv-c2c-sig-dev {

  ### Global attributes ##########################
  $server_group = "development"
  $ps1label = "development"
  $sudo_apache_admin_user = "deploy, %sigdev"
  $sudo_postgresql_admin_user = "deploy, %sigdev"
  $sudo_tomcat_admin_user = "deploy, %sigdev"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-sig
  include mw-apache
  include mw-tomcat
  include mw-postgis-8-4
  include mw-postgresql-8-4

  ### APP (generic) ##############################
  include app-c2c-sig
  include app-c2c-sig-dev
  include app-c2c-remove-ldap-support

  ### APP (specific to this server) ##############
  app::c2c::sadb::users{["all c2c users"]: groups => ["sigdev", "www-data"]}

}
