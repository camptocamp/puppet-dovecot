# Server type used on node !insert node name here!
#

class srv-c2c-openerp-hosted-demo {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "demo hosted"
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'
  $openerp_project = 'demo'
  $openerp_client_contact = 'joel.grandguillaume@camptocamp.com'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-postgresql-8-3
  include mw-openerp
  include mw-openerp-hosted
  include mw-openerp-manager

  ### APP (generic) ##############################
}
