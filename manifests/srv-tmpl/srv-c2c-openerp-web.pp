class srv-c2c-openerp-web {

  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "openerp.camptocamp.com"
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include mw-lamp

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-openerp-web
}
