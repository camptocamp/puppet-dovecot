class postgresql::v8-3::postgis inherits postgresql::v8-3 {

  if defined (Apt::Sources_list["sig-${lsbdistcodename}-c2c"]) {
    notice "Sources-list for SIG packages is already defined"
  } else {
    apt::sources_list {"sig-${lsbdistcodename}-c2c":
      ensure  => present,
      content => "deb http://dev.camptocamp.com/packages ${lsbdistcodename} sig",
    }
  }

  if defined (Apt::Key["A37E4CF5"]) {
     notice "Apt-key for SIG packages is already defined"
  } else {
    apt::key {"A37E4CF5":
      source  => "http://dev.camptocamp.com/packages/debian/pub.key",
    }
  }
   
  package {["postgresql-8.3-postgis", "postgresql-contrib-8.3"]:
    ensure => present,
  }
 
}
