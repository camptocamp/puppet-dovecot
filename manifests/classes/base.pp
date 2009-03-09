#
# Based https://project.camptocamp.com/doc/c2c/CartoWebChroot
#

class mapserver::base {
  $mapserver_packages_release = "20070605"

  apt::sources_list{"mapserver-etch-c2c":
    content => "deb http://dev.camptocamp.com/packages/debian/${mapserver_packages_release} etch main",
  }

  apt::key {"A37E4CF5":
    source  => "http://dev.camptocamp.com/packages/debian/pub.key",
  }


  file { "/etc/apt/preferences":
    mode   => 644,
    source => "puppet:///mapserver/apt-preferences",
  }

  package {
    [
      "php5-common",
      "php5-cli",
      "cvs",
      "php5-mapscript",
      "libapache2-mod-php5",
      "libapache2-mod-fastcgi",
      "libapache2-mod-fcgid",
      "gettext",
      "php5-pgsql",
      "php5-curl",
      "php5-sqlite",
      "libxml2-utils",
      "docbook-xml",
      "proj",
      "php5-mysql",
      "cgi-mapserver",
      "gdal-bin",
      "libecw",
      "libgdal-doc",
      "mapserver-bin",
      "mapserver-doc",
      "perl-mapscript",
      "python-gdal",
      "python-mapscript"
    ]: ensure => present,
  }

  # HACK: proj fixes
  case $lsbdistcodename {
    'etch' : {
      file {"/usr/share/proj/epsg":
        ensure  => present,
        source  => "puppet:///mapserver/epsg.C2C",
        require => Package["proj"],
      }
    }
  }

  # HACK: Pear looks for php_sqlite.so instead of sqlite.so provided by the php5-sqlite package
  # This is required to get the demo working
  file {"/usr/lib/php5/20060613+lfs/php_sqlite.so":
    ensure  => "/usr/lib/php5/20060613+lfs/sqlite.so",
    require => Package["php5-sqlite"],
  }

}
