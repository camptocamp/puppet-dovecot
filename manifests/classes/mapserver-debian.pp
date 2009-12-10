class mapserver::debian {

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
          "proj",
          "gdal-bin",
          "libecw",
          "libapache2-mod-fcgid",
          "python-gdal"
        ]: ensure => present,
      }

      common::concatfilepart { "sig-packages":
        ensure => present,
        file => "/etc/apt/preferences",
        source => "puppet:///mapserver/etc/apt/preferences-v5-2",
      }
    }

    'lenny' : {

      case $epsg_file {
        "tuned","minimal": {
          include mapserver::epsg::minimal
        }
        default: {
          include mapserver::epsg
        }
      }

      apt::preferences { "gis_tools_from_bp.o":
         package => "proj libproj-dev libproj0 proj-bin proj-data libgeos-dev libgeos-c1 libgeos-3.1.0",
         pin => "release a=${lsbdistcodename}-backports",
         priority => "1100";
      }

      package {
        [
          "cgi-mapserver",
          "mapserver-bin",
          "perl-mapscript",
          "php5-mapscript",
          "python-mapscript",
          "gdal-bin",
          "libecw",
          "libapache2-mod-fcgid",
          "python-gdal",
          "proj-bin",
          "proj-data",
          "libgeos-dev",
          "libgeos-c1",
          "libgeos-3.1.0"
        ]:
        ensure => present,
      }
    }
  }

  apache::module {"fcgid":
    ensure  => present,
    require => Package["libapache2-mod-fcgid"],
  }

}
