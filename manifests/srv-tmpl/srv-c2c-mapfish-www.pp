class srv-c2c-mapfish-www {

  ### Global attributes ##########################
  $tomcat_version = "6.0.26"
  $server_group = "prod"
  $sudo_tomcat_admin_user = "admin"
  $sudo_postgresql_admin_user = "admin"
  $sudo_apache_admin_user = "admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include generic-tmpl::mw-postgresql-8-3
  include generic-tmpl::mw-postgresql-8-3
  include mw-sig
  include generic-tmpl::mw-git
  include generic-tmpl::mw-tomcat

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-mapfish-www
}
