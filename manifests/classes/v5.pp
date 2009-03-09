class mapserver::v5 {
  $mapserver_packages_release = "20080225"

  if defined (Apt::Sources_list["sig-etch-c2c"]) {
    notice "Sources-list for SIG packages is already defined"
  } else {
    apt::sources_list {"sig-etch-c2c":
      content => "deb http://dev.camptocamp.com/packages etch sig",
    }
  }

  if defined (Apt::Key["A37E4CF5"]) {
     notice "Apt-key for SIG packages is already defined"
  } else {
    apt::key {"A37E4CF5":
      source  => "http://dev.camptocamp.com/packages/debian/pub.key",
    }
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

}
