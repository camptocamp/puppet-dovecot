class mapserver::v5-2 {

  if defined (Apt::Sources_list["sig-${lsbdistcodename}-c2c"]) {
    notice "Sources-list for SIG packages is already defined"
  } else {
    apt::sources_list {"sig-${lsbdistcodename}-c2c":
      ensure  => present,
      content => "deb http://dev.camptocamp.com/packages ${lsbdistcodename} sig\n",
    }
  }

  if defined (Apt::Key["A37E4CF5"]) {
     notice "Apt-key for SIG packages is already defined"
  } else {
    apt::key {"A37E4CF5":
      source  => "http://dev.camptocamp.com/packages/debian/pub.key",
    }
  }

  package {
    [
      "proj",
      "gdal-bin",
      "libecw",
      "libgdal-doc",
      "libapache2-mod-fcgid",
      "python-gdal",
    ]: ensure => present,
  }

  case $lsbdistcodename {
    'etch' : {

      include mapserver::epsg::legacy

      package {
        [
          "cgi-mapserver-5.2",
          "perl-mapscript-5.2",
          "mapserver-bin-5.2",
          "mapserver-doc-5.2",
          "php5-mapscript-5.2",
          "python-mapscript-5.2",
        ]: ensure => present,
      }
      
      common::concatfilepart { "sig-packages":
        ensure => present,
        file   => "/etc/apt/preferences",
        source => "puppet:///mapserver/etc/apt/preferences-v5-2",
      }   
    }

    'lenny' : {

      case $epsg_file {
        /^puppet:.*/: {
          $custom_epsg = $epsg_file
          include mapserver::epsg::custom
        }
        "tuned","minimal": {
          include mapserver::epsg::minimal
        }
        default: {
          include mapserver::epsg
        }
      }

      package {
        [
          "cgi-mapserver",
          "mapserver-bin",
          "perl-mapscript",
          "php5-mapscript",
          "python-mapscript",
        ]:  ensure => present,
      }
    }
  }

  apache::module {"fcgid":
    ensure  => present,
    require => Package["libapache2-mod-fcgid"],
  }

}
