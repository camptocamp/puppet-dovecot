class mw-apache {

  include apache
  include apache::administration
  include apache::deflate

  if $server_group == "prod" {
#    include monitoring::apache_status
  }
 
}
