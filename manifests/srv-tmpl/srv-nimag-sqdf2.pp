class srv-nimag-sqdf2 {
  $server_group = "prod"
  $ps1label = "avocats.ch www"

  include os-base
  include os-server

  include mw-apache-ssl

  include app-nimag-sqdf2

}
