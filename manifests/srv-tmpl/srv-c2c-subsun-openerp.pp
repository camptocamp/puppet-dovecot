# Server type used on node !insert node name here!
#

class srv-c2c-subsun-openerp {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "subsun hosted"
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'
  $openerp_project = 'subsun'
  $openerp_client_contact = 'olivier.dubois@m4x.org'

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
