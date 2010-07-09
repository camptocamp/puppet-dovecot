## set up nagios if necessary
#
# Requires: mw-openerp

class mw-openerp-prod {

  if $virtual == "openvz" {
    include os-customer-ng-ovz
  }
  include mw-nagios-openerp
  include tmpl-openerp-base
}
