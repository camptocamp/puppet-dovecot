class srv-c2c-peitrequin-hosting {
  $ps1label = "peitrequin-hosting-prod"
  $sudo_tomcat_admin_user = 'admin'
  $sudo_apache_admin_user = 'admin'

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include mw-tomcat
  include mw-sig
  include mw-postgresql-8-3
  include mw-postgis-8-3

  include app-c2c-peitrequin-hosting

}
