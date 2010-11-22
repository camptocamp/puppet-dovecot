class srv-c2c-easy-openerp {
  $server_group = "prod"
  $ps1label = 'easy_openerp proxypass'
  
  $sslcert_country = "CH"
  $sslcert_state = "VD"
  $sslcert_locality = "Lausanne"
  $sslcert_organisation = "Camptocamp SA"
  $sslcert_commonname = "*.easy-openerp.ch"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include generic-tmpl::mw-postgresql-8-3      # TMP_SRV1
  include mw-openerp             # TMP_SRV1
  include mw-easy-openerp        # TMP_SRV1

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
#  include app-easy-openerp-proxypass
  include app-easy-openerp  # TMP_SRV1
}
