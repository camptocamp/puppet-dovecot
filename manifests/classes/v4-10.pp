class mapserver::v4-10 {

  include mapserver::epsg::legacy

  $mapserver_packages_release = "20070910"

  apt::sources_list {"sig-etch-c2c-${mapserver_packages_release}":
    content => "deb http://dev.camptocamp.com/packages/debian/${mapserver_packages_release} etch main",
  }

  apt::key {"A37E4CF5":
    source  => "http://dev.camptocamp.com/packages/debian/pub.key",
  }

  common::concatfilepart { "sig-packages":
    ensure => present,
    file   => "/etc/apt/preferences",
    source => "puppet:///mapserver/etc/apt/preferences-${mapserver_packages_release}",
  }

  package {
    [
      "proj",
      "cgi-mapserver",
      "gdal-bin",
      "libecw",
      "libgdal-doc",
      "mapserver-bin",
      "mapserver-doc",
      "perl-mapscript",
      "php5-mapscript",
      "python-mapscript",
      "libapache2-mod-fastcgi",
      "libapache2-mod-fcgid"
    ]: ensure => present,
  }

}
