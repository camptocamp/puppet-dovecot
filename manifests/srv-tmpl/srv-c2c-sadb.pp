# Server type used on node sadb.int.lsn
#

class srv-c2c-sadb {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $ps1label = "new sadb"

  $wwwroot = "/var/www/"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################
  include mw-apache
  include mw-postgresql-8-3

  ### APP (generic) ##############################

  ### APP (specific to this server) ##############
  include app-c2c-sadb

}
