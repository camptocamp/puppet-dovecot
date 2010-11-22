# Server type used on node !insert node name here!
#

class srv-c2c-openerp-hosted-prod {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include generic-tmpl::mw-postgresql-8-3
  include mw-openerp
  include mw-openerp-hosted
  include mw-openerp-manager

  ### APP (generic) ##############################
}
