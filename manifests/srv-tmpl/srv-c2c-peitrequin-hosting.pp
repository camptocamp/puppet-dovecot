class srv-c2c-peitrequin-hosting {
  $ps1label = "peitrequin-hosting-prod"
  $sudo_tomcat_admin_user = 'admin'
  $sudo_apache_admin_user = 'admin'
  $sudo_postgresql_admin_user = 'admin'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include generic-tmpl::mw-tomcat
  include mw-sig
  include generic-tmpl::mw-postgresql-8-3
  include generic-tmpl::mw-postgis-8-3

  include app-c2c-peitrequin-hosting

}
