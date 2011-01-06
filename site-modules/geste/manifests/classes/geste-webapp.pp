class geste::webapp {

  package {["imagemagick", "php-apc", "python-ldap"]:
    ensure => present,
  }

  apache::vhost {"share":
    aliases => ["gestepc1.epfl.ch", "gestepc3.epfl.ch", $fqdn],
    ensure => present,
  }

  apache::vhost-ssl {"intranet":
    ensure  => present,
    aliases => ["intranet.geste.ch", "intranet.geste"],
    group   => "apache-admin",
    mode    => 2570,
  }

  apache::directive {"proxypass-xapian":
    ensure => present,
    vhost  => "intranet",
    directive => "<Proxy http://localhost:8000/xapian*>
    Order deny,allow
    Allow from all
</Proxy>

ProxyPass /xapian http://localhost:8000/xapian
ProxyPassReverse /xapian http://localhost:8000/xapian
ProxyPreserveHost On
",
  }

  apache::vhost-ssl {"openerp":
    ensure => present,
    aliases => ["openerp.geste.ch", "openerp.geste"],
  }

  mysql::database {"openupload":
    ensure => present,
  }

  mysql::rights {"openupload on openupload":
    database => "openupload",
    user     => "openupload",
    password => "thaiBahcah2AeTh",
    require  => Mysql::Database["openupload"],
  }

  apache::directive {"slash":
    vhost     => "share",
    directive => "DocumentRoot /var/www/share/htdocs/openupload-0.4.2",
  }

  common::archive {"openupload-0.4.2.tar.gz":
    url      => "http://switch.dl.sourceforge.net/project/openupload/openupload/v0.4/openupload-0.4.2.tar.gz",
    checksum => false,
    target   => "/var/www/share/htdocs",
    root_dir => "openupload-0.4.2",
    require  => Apache::Vhost["share"],
  }

  file {"/var/www/share/htdocs/openupload-0.4.2/www/config.inc.php":
    ensure => present,
    owner  => root,
    group  => www-data,
    mode   => 0660,
    source => "puppet:///modules/geste/webapp/openupload.config.inc.php",
    require => Common::Archive["openupload-0.4.2.tar.gz"],
    replace => false,
  }

  file {"/var/www/share/htdocs/openupload-0.4.2/templates_c":
    ensure  => directory,
    owner   => root,
    group   => www-data,
    mode    => 0770,
    require => Common::Archive["openupload-0.4.2.tar.gz"],
  }

  file {"/var/www/share/private/userfiles":
    ensure => directory,
    group  => "www-data",
    mode   => 2775,
  }

  file {"/etc/php5/apache2/conf.d/upload.ini":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    notify => Exec["apache-graceful"],
    content => '; File managed by puppet
upload_max_filesize = 2048M
',
  }

}
