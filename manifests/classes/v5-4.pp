class mapserver::v5-4 {

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
      fail 'MapServer 5.4 not supported on Debian Etch'
    }

    'lenny' : {
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
