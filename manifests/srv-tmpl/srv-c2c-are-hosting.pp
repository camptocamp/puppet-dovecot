class srv-c2c-are-hosting {
  ### Global attributes ##########################
  $server_group = "prod"
  $ps1label = "are hosting"
  $sudo_apache_admin_user = "%sigdev"
  $sudo_postgresql_admin_user = " %sigdev"
  $sudo_mysql_admin_user = " %sigdev"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include mw-mysql
  include mw-sig
  include generic-tmpl::mw-postgresql-8-3
  include generic-tmpl::mw-postgis-8-3

  include app-c2c-are-hosting

}
