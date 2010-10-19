# Class for specifics for srv-c2c-nagios
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-nagios {

  include nagios
  include nagios::nsca::server
  include nagios::nrpe::server
  include nagios::webinterface


  nagios::local::hostgroup { [
    "ovz-host"
    
    ]:
  }

  apache::vhost-ssl{$fqdn:
    ensure => present,
    aliases => [$hostname, "monitoring.camptocamp.net", "monitoring"],
  }
  apache::auth::htpasswd{"nagiosadmin":
    vhost         => "$fqdn",
    username      => "nagiosadmin",
    cryptPassword => "/Rp7cgng51buI",
    userFileName  => "nagios-htpasswd",
  }

  apache::directive {"nagios-only-ssl":
    ensure => present,
    vhost  => "$fqdn",
    directive => "
RewriteEngine On
RewriteCond   %{SERVER_PORT}  !^443$
RewriteRule ^(.*)$ https://c2cpc27.camptocamp.com/ [L,R=301]

RewriteRule ^/$ /nagios3/ [L,R=301]
"
  }

  apache::directive {"nagios-config":
    ensure    => present,
    vhost     => "$fqdn",
    directive => "
ScriptAlias /cgi-bin/nagios3     /usr/lib/cgi-bin/nagios3/
ScriptAlias /nagios3/cgi-bin     /usr/lib/cgi-bin/nagios3/
Alias       /nagios3/stylesheets /etc/nagios3/stylesheets
Alias       /nagios3             /usr/share/nagios3/htdocs

<DirectoryMatch (/usr/lib/cgi-bin/nagios3/|/usr/share/nagios3)>
  Options FollowSymLinks ExecCGI Indexes
  AllowOverride AuthConfig
  Order Allow,Deny
  Allow From All
</DirectoryMatch>
",
  }

  apache::directive{"nagios-access":
    ensure    =>  present,
    vhost     => "$fqdn",
    directive => "
<Location />
  Order deny,allow
  Deny from all
  Allow from 10.27.0.0/16
  Allow from 128.179.66.0/24

  AuthName \"Nagios Access\"
  AuthType Basic
  AuthUserFile /var/www/$fqdn/private/nagios-htpasswd
  require valid-user
</Location>
",
  }

}
