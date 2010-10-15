# Class for specifics for srv-c2c-www
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-www {

  ## Basic

  user {"admin":
    ensure => present,
  }
  group {"admin":
    ensure => present,
  }


  ## MySQL

  include mysql::server

  mysql::database {"c2ccorp":
    ensure => present,
  }
  mysql::database {"c2ccorp_test":
    ensure => present,
  }

  mysql::rights {"c2ccorp on c2ccorp":
    ensure => present,
    database => "c2ccorp",
    user => "c2ccorp",
    password => "c2ccorp",
    require => Mysql::Database["c2ccorp"],
  }
  mysql::rights {"c2ccorp on c2ccorp_test":
    ensure => present,
    database => "c2ccorp_test",
    user => "c2ccorp",
    password => "c2ccorp",
    require => Mysql::Database["c2ccorp_test"],
  }



  ## Apache

  apache::vhost {"www.camptocamp.com":
    ensure    => present,
    group     => admin,
    mode      => 2775,
    aliases => [
      "c2cpc20.camptocamp.com",
      "c2cpc20",
      "camptocamp.com",
      "camptocamp.net",
      "www.camptocamp.net",
      "camptocamp.at",
      "www.camptocamp.at",
      "camptocamp.fr",
      "www.camptocamp.fr",
      "camptocamp.info",
      "www.camptocamp.info",
      "www.openerp-alliance.ch",
      "openerp-alliance.ch",
      "www.osgeo.eu",
      "osgeo.eu",
      "camptocamp.eu",
      "www.camptocamp.eu",
      "postgis.eu",
      "www.postgis.eu",
      "cartoweb.eu",
      "www.cartoweb.eu",
      "mapserver.eu",
      "www.mapserver.eu",
      "logicielslibres.eu",
      "www.logicielslibres.eu",
      "camp2camp.eu",
      "www.camp2camp.eu",
      "mygis.eu",
      "www.mygis.eu",
      "maptools.eu",
      "www.maptools.eu",
      "fossgis.eu",
      "www.fossgis.eu",
      "www.camptocamp.ch",
      "camptocamp.ch",
      "www.camp2camp.ch",
      "camp2camp.ch",
    ],
  }

  apache::directive {"redirect":
    ensure    => present,
    directive => template("c2c/redirect-www.camptocamp.com.erb"),
    vhost     => "www.camptocamp.com",
  }
 

  c2c::checkexternalurl::export {"www.camptocamp.com":
    path   => "/modules/mod_jflanguageselection/tmpl/mod_jflanguageselection.css",
  }

  include apache::awstats

  apache::aw-stats{"www.camptocamp.com":
    ensure => present,
  }

  apache::auth::basic::file::user {"c2c":
    ensure       => present,
    vhost        => "www.camptocamp.com",
    location     => "/stats",
    authUserFile => "/var/www/www.camptocamp.com/private/htpasswd",
  }

  # Joomla files and directories that need to be writeable by Apache
  file {"/var/www/www.camptocamp.com/htdocs/configuration.php":
    ensure => present,
    owner  => admin,
    group  => www-data,
    mode   => 664,
  }
  file {[
    "/var/www/www.camptocamp.com/htdocs/cache",
    "/var/www/www.camptocamp.com/htdocs/components",
    "/var/www/www.camptocamp.com/htdocs/images",
    "/var/www/www.camptocamp.com/htdocs/language",
    "/var/www/www.camptocamp.com/htdocs/media",
    "/var/www/www.camptocamp.com/htdocs/modules",
    "/var/www/www.camptocamp.com/htdocs/plugins",
    "/var/www/www.camptocamp.com/htdocs/templates",
    "/var/www/www.camptocamp.com/htdocs/tmp",

    "/var/www/www.camptocamp.com/htdocs/administrator/backups",
    "/var/www/www.camptocamp.com/htdocs/administrator/cache",
    "/var/www/www.camptocamp.com/htdocs/administrator/components",
    "/var/www/www.camptocamp.com/htdocs/administrator/language",
    "/var/www/www.camptocamp.com/htdocs/administrator/modules",
    "/var/www/www.camptocamp.com/htdocs/administrator/templates",

    "/var/www/www.camptocamp.com/htdocs/administrator/language/en-GB",
    "/var/www/www.camptocamp.com/htdocs/administrator/language/fr-FR",

    "/var/www/www.camptocamp.com/htdocs/images/banners",
    "/var/www/www.camptocamp.com/htdocs/images/stories",

    "/var/www/www.camptocamp.com/htdocs/plugins/content",
    "/var/www/www.camptocamp.com/htdocs/plugins/editors",
    "/var/www/www.camptocamp.com/htdocs/plugins/search",
    "/var/www/www.camptocamp.com/htdocs/plugins/system",
    "/var/www/www.camptocamp.com/htdocs/plugins/tmp",

    "/var/www/www.camptocamp.com/htdocs/language/en-GB",
    "/var/www/www.camptocamp.com/htdocs/language/fr-FR"
    ]:
    owner => admin,
    group => www-data,
    mode  => 2775,
  }


  ## Testing

  apache::vhost{"wwwtest.camptocamp.net":
    ensure => present,
    user   => admin,
    group  => admin,
    mode   => 2775,
  }
  apache::auth::htpasswd{"wwwtest-user":
    vhost    => "wwwtest.camptocamp.net",
    username => "wwwtest",
    clearPassword => "fD63Vya7",
  }
  apache::auth::basic::file::user {"wwwtest-access":
   vhost => "wwwtest.camptocamp.net",
   users => "wwwtest",
  }

  # Joomla files and directories that need to be writeable by Apache
  file {"/var/www/wwwtest.camptocamp.net/htdocs/configuration.php":
    ensure => present,
    owner  => admin,
    group  => www-data,
    mode   => 664,
  }
  file {[
    "/var/www/wwwtest.camptocamp.net/htdocs/cache",
    "/var/www/wwwtest.camptocamp.net/htdocs/components",
    "/var/www/wwwtest.camptocamp.net/htdocs/images",
    "/var/www/wwwtest.camptocamp.net/htdocs/language",
    "/var/www/wwwtest.camptocamp.net/htdocs/media",
    "/var/www/wwwtest.camptocamp.net/htdocs/modules",
    "/var/www/wwwtest.camptocamp.net/htdocs/plugins",
    "/var/www/wwwtest.camptocamp.net/htdocs/templates",
    "/var/www/wwwtest.camptocamp.net/htdocs/tmp",

    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/backups",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/cache",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/components",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/language",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/modules",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/templates",

    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/language/en-GB",
    "/var/www/wwwtest.camptocamp.net/htdocs/administrator/language/fr-FR",

    "/var/www/wwwtest.camptocamp.net/htdocs/images/banners",
    "/var/www/wwwtest.camptocamp.net/htdocs/images/stories",

    "/var/www/wwwtest.camptocamp.net/htdocs/plugins/content",
    "/var/www/wwwtest.camptocamp.net/htdocs/plugins/editors",
    "/var/www/wwwtest.camptocamp.net/htdocs/plugins/search",
    "/var/www/wwwtest.camptocamp.net/htdocs/plugins/system",
    "/var/www/wwwtest.camptocamp.net/htdocs/plugins/tmp",

    "/var/www/wwwtest.camptocamp.net/htdocs/language/en-GB",
    "/var/www/wwwtest.camptocamp.net/htdocs/language/fr-FR"
    ]:
    owner => admin,
    group => www-data,
    mode  => 2775,
  }


}
