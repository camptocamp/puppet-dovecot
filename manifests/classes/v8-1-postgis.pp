class postgresql::v8-1::postgis inherits postgresql::v8-1 {
  
  case $lsbdistcodename {
    etch: {
      package {["postgresql-8.1-postgis", "postgresql-contrib-8.1"]:
        ensure => present,
      }
    }
    default: {
      fail "postgis version not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
 
}
