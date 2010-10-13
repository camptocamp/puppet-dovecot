class mw-postgis-8-3 {

  class c2c::postgis inherits postgis::debian::v8-3 {
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

    Exec["create postgis_template"] {
      require +> Class["mw-postgresql-8-3"],
    }

    Package["postgis"] {
      require +> [
        Apt::Sources_list["sig-${lsbdistcodename}-c2c"],
        Apt::Key["A37E4CF5"],
      ]
    }
  }

  include c2c::postgis

}
