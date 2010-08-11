class mw-postgis-8-4 {

  class c2c::postgis inherits postgis::debian::v8-4 {
    if defined (Apt::Sources_list["sig-${lsbdistcodename}-postgresql-8.4"]) {
      notice "Sources-list for SIG packages is already defined"
    } else {
      apt::sources_list {"sig-${lsbdistcodename}-postgresql-8.4":
        ensure  => present,
        content => "deb http://dev.camptocamp.com/packages lenny postgresql-8.4\n",
      }
    }

    if defined (Apt::Key["A37E4CF5"]) {
      notice "Apt-key for SIG packages is already defined"
    } else {
      apt::key {"A37E4CF5":
        source  => "http://dev.camptocamp.com/packages/debian/pub.key",
      }
    }

    Apt::Preferences["postgresql-8.4-postgis"] {
      pin => "release o=c2c",
    }

    Package["postgis"] {
      require +> [
        Apt::Sources_list["sig-${lsbdistcodename}-postgresql-8.4"],
        Apt::Key["A37E4CF5"],
      ]
    }
  }

  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        lenny :  { include c2c::postgis }
        default: { fail "mw::postgis::8-4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    Ubuntu: {
      case $lsbdistcodename {
        lucid : { include postgis }
        default: { fail "mw::postgis::8-4 not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

}
