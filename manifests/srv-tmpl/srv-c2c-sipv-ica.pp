class srv-c2c-sipv-ica {
  $server_group = "prod"
  $ps1label = "sipv_ica-demo"
  $sudo_apache_admin_user = "%admin"
  $sudo_postgresql_admin_user = "%admin"
  $sudo_tomcat_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server


 ### MW #########################################
  include mw-apache
  include mw-sig
  include generic-tmpl::mw-postgresql-8-3
  include generic-tmpl::mw-postgis-8-3
  include generic-tmpl::mw-tomcat

  include app-c2c-sipv-ica
}
