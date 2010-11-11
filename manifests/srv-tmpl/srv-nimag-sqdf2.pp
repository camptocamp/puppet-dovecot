class srv-nimag-sqdf2 {
  $server_group = "prod"
  $ps1label = "avocats.ch www"
  $is_external = true

  $sudo_apache_admin_user = 'subilia'

  $slapd_admin_passwd = "1FkJX/ukay1Xg"
  $slapd_passwd = "c2c"
  $slapd_allow_v2 = "false"
  $slapd_organisation = "Etude SQDF"
  $slapd_domain = "artemis"
  $slapd_purge_old = "true"


  include os-base
  include os-server

  include mw-apache-ssl

  include app-nimag-sqdf2

}
