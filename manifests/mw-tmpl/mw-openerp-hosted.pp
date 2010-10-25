# OpenERP Hosted part
#
# Requires:
# Provides: 
# Conflicts: 
#

class mw-openerp-hosted {


  include apache::ssl
  include apache::administration

  # bazaar configuration
  file {"/root/.bazaar":
    ensure => directory,
  }

  file {"/root/.bazaar/authentication.conf":
    ensure => present,
    content => "[DEFAULT]
user=c2c_tinyerp
password=Aevei8ae
",
  }

  # postgresql config
  file {"/etc/postgresql/8.3/main/pg_hba.conf":
    ensure  => present,
    mode    => 0640,
    owner   => postgres,
    group   => postgres,
    require => Package["postgresql"],
    notify  => Service["postgresql"],
    content => "
# static file managed by puppet. NO common::line allowed. use app-openerp-hosted to edit it
local   all         postgres                      ident sameuser
local   all         openerp                       ident sameuser

local   samerole    all                           ident sameuser

local   all         all                           md5

host    all         all         127.0.0.1/32      md5
host    samerole    all         127.0.0.1/32      md5
host    samerole    all         ::1/128           md5
",
  }

  # apache configuration
  apache::module{["proxy","proxy_http"]:
    require => Class["apache::ssl"]
  }

  file {"/etc/apache2/conf.d/vhost-ssl.conf":
    ensure => present,
    content => "NameVirtualHost *:443\n",
    owner   => root,
    group   => root,
    mode    => 644,
    require => Class["apache::ssl"],
  }

  # vhosts definition
  apache::vhost-ssl {
    "${openerp_project}-prod":
      ensure  => present,
      cert    => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
      certkey => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
      aliases => ["${openerp_project}-prod.hosted-camptocamp.com"];
    "${openerp_project}-test":
      ensure  => present,
      cert    => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
      certkey => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
      aliases => ["${openerp_project}-test.hosted-camptocamp.com"];
    "${openerp_project}-qa":
      ensure  => present,
      cert    => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
      certkey => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
      aliases => ["${openerp_project}-qa.hosted-camptocamp.com"];
    "${openerp_project}-int":
      ensure  => present,
      cert    => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
      certkey => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
      aliases => ["${openerp_project}-int.hosted-camptocamp.com"];
  }
 
  apache::vhost-ssl {"${openerp_project}":
    ensure => present,
    aliases => ["${openerp_project}.hosted-camptocamp.com"],
    cert    => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
    certkey => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
  }

  # some vhost configurations
  ## ssl only
  apache::directive {"ssl-only-prod":
    vhost     => "${openerp_project}-prod",
    ensure    => present,
    directive => '
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1
',    
  }
  apache::directive {"ssl-only-test":
    vhost     => "${openerp_project}-test",
    ensure    => present,
    directive => '
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1
',    
  }
  apache::directive {"ssl-only-qa":
    vhost     => "${openerp_project}-qa",
    ensure    => present,
    directive => '
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1
',    
  }
  apache::directive {"ssl-only-int":
    vhost     => "${openerp_project}-int",
    ensure    => present,
    directive => '
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1
',    
  }
   apache::directive {"ssl-only":
    vhost     => "${openerp_project}",
    ensure    => present,
    directive => '
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1
',    
  }

  ## openerp webclient proxypass
  apache::directive {"webclient-prod":
    ensure => present,
    vhost  => "${openerp_project}-prod",
    directive => '
<Proxy *>
  Order Allow,Deny
  Allow from All
</Proxy>
ProxyPass /static !
ProxyPass / http://localhost:8080/
ProxyPassReverse / http://localhost:8080/
Alias /static /srv/openerp/instances/prod/src/web-client/openerp/static
<Directory /srv/openerp/instances/prod/src/web-client/openerp/static>
  Order allow,deny
  Allow from All
</Directory>
',
  }

  apache::directive {"webclient-test":
    ensure => present,
    vhost  => "${openerp_project}-test",
    directive => '
<Proxy *>
  Order Allow,Deny
  Allow from All
</Proxy>
ProxyPass /static !
ProxyPass / http://localhost:8380/
ProxyPassReverse / http://localhost:8380/
Alias /static /srv/openerp/instances/prod/src/web-client/openerp/static
<Directory /srv/openerp/instances/prod/src/web-client/openerp/static>
  Order allow,deny
  Allow from All
</Directory>
',
  }

  apache::directive {"webclient-qa":
    ensure => present,
    vhost  => "${openerp_project}-qa",
    directive => '
<Proxy *>
  Order Allow,Deny
  Allow from All
</Proxy>
ProxyPass /static !
ProxyPass / http://localhost:8280/
ProxyPassReverse / http://localhost:8280/
Alias /static /srv/openerp/instances/prod/src/web-client/openerp/static
<Directory /srv/openerp/instances/prod/src/web-client/openerp/static>
  Order allow,deny
  Allow from All
</Directory>
',
  }

  apache::directive {"webclient-integration":
    ensure => present,
    vhost  => "${openerp_project}-int",
    directive => '
<Proxy *>
  Order Allow,Deny
  Allow from All
</Proxy>
ProxyPass /static !
ProxyPass / http://localhost:8280/
ProxyPassReverse / http://localhost:8280/
Alias /static /srv/openerp/instances/prod/src/web-client/openerp/static
<Directory /srv/openerp/instances/prod/src/web-client/openerp/static>
  Order allow,deny
  Allow from All
</Directory>
',
  }


  # openerp certificates - we take the same as apache
  file {"/srv/openerp/ssl":
    ensure  => directory,
    owner   => openerp,
    group   => openerp,
    mode    => 0600,
    require => User["openerp"],
  }
  
  file {"/srv/openerp/ssl/${openerp_project}.key":
    ensure  => present,
    owner   => openerp,
    group   => openerp,
    mode    => 0600,
    source  => "puppet:///c2c/ssl/hosted-camptocamp.com.key",
    require => File["/srv/openerp/ssl"],
  }

  file {"/srv/openerp/ssl/${openerp_project}.crt":
    ensure  => present,
    owner   => openerp,
    group   => openerp,
    mode    => 0600,
    source  => "puppet:///c2c/ssl/hosted-camptocamp.com.crt",
    require => File["/srv/openerp/ssl"],
  }

  # add some rights for openerp user (sudo)
  common::concatfilepart {"openerp more rights":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "%openerp ALL=(ALL) NOPASSWD: /usr/local/bin/integration-replicate,/usr/local/bin/qa-replicate\n",
  }

  # scripts (will be removed later when MOA is ready)
  $openerp_server_src = 'http://bazaar.launchpad.net/%7Eopenerp/openobject-server/5.0/'
  $openerp_addons_src = 'http://bazaar.launchpad.net/%7Eopenerp/openobject-addons/5.0/'
  $openerp_extras_src = 'http://bazaar.launchpad.net/%7Eopenerp-commiter/openobject-addons/stable_5.0-extra-addons/'
  $openerp_webcli_src = 'http://bazaar.launchpad.net/%7Eopenerp/openobject-client-web/5.0/'
  $openerp_webcli_rvn = '2568'

  file {"/usr/local/bin/qa-replicate":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    content => template("c2c/openerp-qa-duplicate.erb"),
  }

  file {"/usr/local/bin/integration-replicate":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    content => template("c2c/openerp-integration-duplicate.erb"),
  }

}
