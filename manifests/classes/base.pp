class tilecache::base {

  if defined (Apt::Sources_list["sig-${lsbdistcodename}-c2c"]) {
    notice "Sources-list for SIG packages is already defined"
  } else {
    apt::sources_list{"sig-${lsbdistcodename}-c2c":
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
      "tilecache", 
      "python-imaging", 
      "libapache2-mod-python",
      "jpegoptim",
      "jpeginfo",
      "optipng",
      "pngcheck"
    ]:
    ensure  => present,
  }

  case $lsbdistcodename {
    'etch' : {
      apache::module {"mod_python":
        ensure  => present,
        require => Package["libapache2-mod-python"],
      }
    }
    'lenny' : {
      apache::module {"python":
        ensure  => present,
        require => Package["libapache2-mod-python"],
      }
    }
  }

  apache::module {"expires":
    ensure => present,
  }

  file {"/var/cache/tilecache":
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 2775,
  }
}
