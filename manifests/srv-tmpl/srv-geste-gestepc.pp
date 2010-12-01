# Server type used on node !insert node name here!
#

class srv-geste-gestepc {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $is_external = true

  $samba_domain_name = "GESTDOMAIN"
  $samba_netbios_name = "FILESERVER"
  $ldap_uri = "ldap://127.0.0.1"
  $ldap_base = "cn=admin,dc=ldap,dc=geste"
  $ldap_admin_password = "aic3waeB"
  $ldap_suffix = "dc=ldap,dc=geste"
  $slapd_admin_passwd = $ldap_admin_password
  $slapd_passwd = $ldap_admin_password
  $slapd_organisation = "GESTE Ingeneer"
  $slapd_allow_v2 = "false"
  $slapd_purge_old = "false"
  $slapd_domain = "ldap.geste"

  ### OS #########################################
  include os-base
  include os-server


  ### MW #########################################
  include mw-apache-ssl
  include mw-lamp

  ### APP ########################################

  include geste::baseconfig
  include geste::network
  include geste::dns
#  include geste::dhcp
  include geste::ldap
  include geste::samba
  include geste::mail
  include geste::webapp

}
