class app-easy-openerp {

  postgresql::user {"openerp_easy":
    ensure   => present,
    password => "roosaeti",
  }

  postgresql::database {"demo":
    ensure   => present,
    owner    => "openerp_easy",
    encoding => "utf-8",
    require  => [Postgresql::User["openerp_easy"],File["/srv/openerp/easy_openerp.dump.gz"]],
    source   => "/srv/openerp/easy_openerp.dump.gz",
  }

  postgresql::database {"1coach":
    ensure   => present,
    owner    => "openerp_easy",
    encoding => "utf-8",
    require  => [Postgresql::User["openerp_easy"],File["/srv/openerp/easy_openerp.dump.gz"]],
    source   => "/srv/openerp/easy_openerp.dump.gz",
  }

  include apache::ssl
  include apache::deflate

  apache::directive {"setenv-proxy":
    vhost     => "www.easy-openerp.ch",
    directive => "SetEnv proxy-nokeepalive 1",
  }

  apache::module{ ["proxy", "proxy_http"]:
    ensure => present,
  }

  apache::vhost-ssl {"www.easy-openerp.ch":
    aliases => ["*"],
    ensure  => present,
    cert    => "puppet:///c2c/ssl/easy-openerp.ch.crt",
    certkey => "puppet:///c2c/ssl/easy-openerp.ch.key"
  }

  apache::directive {"redirect-to-ssl":
    vhost => "www.easy-openerp.ch",
    directive => "# file managed by puppet
RewriteEngine On
RewriteCond   %{HTTPS} off
RewriteRule   ^/(.*)$ https://%{SERVER_NAME}/$1 [L]
",
  }

  apache::proxypass {"web client":
    ensure => present,
    location => "/",
    url      => "http://localhost:8080/",
    vhost    => "www.easy-openerp.ch",
  }

}
