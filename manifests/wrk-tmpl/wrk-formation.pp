class wrk-formation {

  ### Global attributes ##########################
  $ps1label = "wrk-formation"
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"
  $sudo_tomcat_admin_user = "%admin"

  ### OS #########################################
  include os-base
  
  ### MW #########################################
  include mw-apache
  include mw-java-v6
  include generic-tmpl::mw-tomcat
  include generic-tmpl::mw-postgresql-8-4
  include generic-tmpl::mw-postgis-8-4

  ### APP (generic) ##############################
  include app-workstation-tuning
  include app-c2c-workstation-packages

  ### APP (specific to this server) ##############
  include app-c2c-workstation-formation
  include app-c2c-workstation-formation-sig
  include app-c2c-workstation-formation-openerp

}
