class postgresql::v8-3::postgis inherits postgresql::v8-3 {
  
  case $lsbdistcodename {
    lenny: {
      package {["postgresql-8.3-postgis", "postgresql-contrib-8.3"]:
        ensure => present,
      }
    }
    default: {
      fail "postgis version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
 
}
