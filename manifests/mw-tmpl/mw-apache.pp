class mw-apache {

  include apache
  include apache::administration
  include apache::deflate

  if $server_group == "prod" {
    nagios::service::distributed{"check_apachestatus!localhost!80":
      ensure => present,
      service_description => "apache2 status",
      contact_groups => $nagios_contact_groups,
    }
  }
 
}
