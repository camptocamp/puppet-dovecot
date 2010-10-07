# Server type used on node !insert node name here!
#

class srv-c2c-openerp-oneshot {

  ### Global attributes ##########################
  $server_group = "demo" #(one of dev, demo or prod)
  $ps1label = "debonix erp"
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'
  $openerp_project = 'debonix'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-postgresql-8-4
  include mw-openerp

  ### APP (generic) ##############################

}
