# Class for specifics for srv-c2c-sig-tileworkerdemo-foss4g.pp
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-sig-tileworkerdemo-foss4g {

  #include mysql::server

  ## Apache

  apache::vhost {$fqdn:
    ensure    => present,
  }

  #apache::auth::basic::file::user {"c2c":
  #  ensure       => present,
  #  vhost        => "www.camptocamp.com",
  #  location     => "/stats",
  #  authUserFile => "/var/www/www.camptocamp.com/private/htpasswd",
  #}

}
