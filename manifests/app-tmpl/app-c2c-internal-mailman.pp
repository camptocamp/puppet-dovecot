class app-c2c-internal-mailman {

#TODO: import xapian from sa.camptocamp.com and update it
  include mailman
  include postfix::mailman
#  include xapian::mailman
  include mw-xapian-client


  apache::vhost {"lists.camptocamp.com":
    ensure  => present,
    aliases => "lists",
  }

  mailman::instance {"lists.camptocamp.com":
    vhost         => "lists.camptocamp.com",
    #require       => Class["xapian::mailman"],
  }

  mailman::checkpw {
    "Check password of formation": name => "formation", url => "http://lists.camptocamp.com/cgi-bin/mailman/admin", password => "saeQuaed5A", require => Maillist["formation"];
    "Check password of business": name => "business", url => "http://lists.camptocamp.com/cgi-bin/mailman/admin", password => "jeesif4ohN", require => Maillist["business"];
    "Check password of infrastructure": name => "infrastructure", url => "http://lists.camptocamp.com/cgi-bin/mailman/admin", password => "pae8aYooth", require => Maillist["infrastructure"];
    "Check password of geospatial": name => "geospatial", url => "http://lists.camptocamp.com/cgi-bin/mailman/admin", password => "aeZ1mee6Av", require => Maillist["geospatial"];
    "Check password of cdo": name => "cdo", url => "http://lists.camptocamp.com/cgi-bin/mailman/admin", password => "agheeyohS0", require => Maillist["cdo"];
  }

  maillist {
    "formation":      ensure => present, provider => mailman, require => Mailman::Instance["lists.camptocamp.com"], admin => "yves.jacolin@camptocamp.com",        password => "saeQuaed5A", description => "Mailing interne Formation";
    "business":       ensure => present, provider => mailman, require => Mailman::Instance["lists.camptocamp.com"], admin => "joel.grandguillaume@camptocamp.com", password => "jeesif4ohN", description => "Mailing interne Business";
    "infrastructure": ensure => present, provider => mailman, require => Mailman::Instance["lists.camptocamp.com"], admin => "mathieu.bornoz@camptocamp.com",      password => "pae8aYooth", description => "Mailing interne Infrastructure";
    "geospatial":     ensure => present, provider => mailman, require => Mailman::Instance["lists.camptocamp.com"], admin => "emmanuel.belo@camptocamp.com",      password => "aeZ1mee6Av", description => "Mailing interne Geospatial"; # Anciennement cedric.moullet@camptocamp.com
    "cdo":            ensure => present, provider => mailman, require => Mailman::Instance["lists.camptocamp.com"], admin => "luc.maurer@camptocamp.com",          password => "agheeyohS0", description => "Mailing interne CDO";
  }

  # Accept non-member if from camptocamp.com domain
  $ml_net = "['^.*\\@camptocamp\\.com$']"
  mailman::config {
    "set accept_these_nonmembers on formation":      ensure => present, variable => "accept_these_nonmembers", value => $ml_net, mlist => "formation";
    "set accept_these_nonmembers on business":       ensure => present, variable => "accept_these_nonmembers", value => $ml_net, mlist => "business";
    "set accept_these_nonmembers on infrastructure": ensure => present, variable => "accept_these_nonmembers", value => $ml_net, mlist => "infrastructure";
    "set accept_these_nonmembers on geospatial":     ensure => present, variable => "accept_these_nonmembers", value => $ml_net, mlist => "geospatial";
    "set accept_these_nonmembers on cdo":            ensure => present, variable => "accept_these_nonmembers", value => $ml_net, mlist => "cdo";
  }

  # Attachment size
  $ml_attachment_size = 4096 # in KB
  mailman::config {
    "set max_message_size on formation":      ensure => present, variable => "max_message_size", value => $ml_attachment_size, mlist => "formation";
    "set max_message_size on business":       ensure => present, variable => "max_message_size", value => $ml_attachment_size, mlist => "business";
    "set max_message_size on infrastructure": ensure => present, variable => "max_message_size", value => $ml_attachment_size, mlist => "infrastructure";
    "set max_message_size on geospatial":     ensure => present, variable => "max_message_size", value => $ml_attachment_size, mlist => "geospatial";
    "set max_message_size on cdo":            ensure => present, variable => "max_message_size", value => $ml_attachment_size, mlist => "cdo";
  }

  apache::directive {"slash":
    ensure    => present,
    vhost     => "lists.camptocamp.com",
    directive => "
RewriteEngine on                                                                                                                                                                                                                                                     
RewriteRule ^/$ http://lists.camptocamp.com/mailman/listinfo/                                                                                                                                                                                                        
RewriteRule ^/lists$ http://lists.camptocamp.com/mailman/listinfo/
RewriteRule ^/admin$ http://lists.camptocamp.com/mailman/admin/
",
  }

  apache::directive {"no-ext-access":
    ensure    => present,
    vhost     => "lists.camptocamp.com",
    directive => '
<Location />
  AuthType basic
  AuthBasicProvider ldap
  AuthLDAPURL "ldap://ldap.lsn.camptocamp.com ldap.cby.camptocamp.com/dc=ldap,dc=c2c?uid??(sambaSID=*)"
  AuthLDAPGroupAttribute memberUid
  AuthLDAPGroupAttributeIsDN off

  AuthName "Private Area"
  require valid-user

  order deny,allow
  deny from all
  allow from 10.27.10. # wrk.lsn
  allow from 10.26.10. # wrk.cby
  allow from 10.25.40. # vpn
  allow from 128.179.66.82 # puppet (check-password)
  Satisfy Any
</Location>
',
  }


}
