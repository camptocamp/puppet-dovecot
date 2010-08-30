class srv-kartenportal {
  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "kartenportal hosting"
  $sudo_lighttpd_admin_user = "%admin"

  ### OS #########################################
  include os-base
  include os-server

  #include lighttpd
  include lighttpd::administration

  #include app-kartenportal
}
