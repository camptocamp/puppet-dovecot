# Server type used on node !insert node name here!
#

class srv-vrenaville-openerp-hosted {

  ### Global attributes ##########################
  $server_group = "dev" #(one of dev, demo or prod)
  $ps1label = "vrenaville erp"
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'
  $openerp_project = 'vrenaville'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include generic-tmpl::mw-postgresql-8-3
  include mw-openerp
  include mw-openerp-hosted
  include mw-openerp-manager

  ### APP (generic) ##############################

  include app-vrenaville-opernep-hosted
}
