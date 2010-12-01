class geste::webapp {

  package {["imagemagick", "php-apc"]:
    ensure => present,
  }

  apache::vhost {"share":
    aliases => ["gestepc1.epfl.ch", "gestepc3.epfl.ch", $fqdn],
    ensure => present,
  }

  apache::vhost-ssl {"intranet":
    ensure => present,
    aliases => ["intranet.geste.ch", "intranet.geste"],
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

}
