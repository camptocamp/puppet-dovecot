# Server type used on node !insert node name here!
#

class srv-c2c-openerp-aws {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "aws - OpenERP"
  $sudo_apache_admin_user = 'openerp'
  $sudo_postgresql_admin_user = 'openerp'
  $openerp_project = 'openerp'
  $is_external = true

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include generic-tmpl::mw-postgresql-8-4
  include mw-openerp

  ### APP (generic) ##############################

}
