/*

==Class: postgresql::debian::v8-3

Parameters:
 $postgresql_data_dir:
   set the data directory path, which is used to store all the databases

Requires:
 - Class["apt::preferences"]

*/
class postgresql::debian::v8-3 inherits postgresql::debian::base {

  $data_dir = $postgresql_data_dir ? {
    "" => "/var/lib/postgresql",
    default => $postgresql_data_dir,
  }

  if $lsbdistcodename == "etch" {
    apt::preferences {[
      "libpq-dev",
      "libpq5",
      "postgresql-8.3",
      "postgresql-client-8.3",
      "postgresql-common", 
      "postgresql-client-common",
      "postgresql-contrib-8.3"
      ]:
      pin => "release a=${lsbdistcodename}-backports",
      priority => "1100"
    }
  }

  case $lsbdistcodename {
    "etch", "lenny" : {
      package {[
        "libpq-dev",
        "libpq5",
        "postgresql-client-8.3",
        "postgresql-common",
        "postgresql-client-common",
        "postgresql-contrib-8.3"
        ]:
        ensure  => present,
      }
  
      Package["postgresql"] {
        name => "postgresql-8.3",
      }

      Service["postgresql"] {
        name => "postgresql-8.3",
      }
  
      # re-create the cluster in UTF8
      exec {"pg_createcluster in utf8" :
        command => "pg_dropcluster --stop 8.3 main && pg_createcluster -e UTF8 -d ${data_dir}/8.3/main --start 8.3 main",
        onlyif => "test \$(su -c \"psql -tA -c 'SELECT count(*)=3 AND min(encoding)=0 AND max(encoding)=0 FROM pg_catalog.pg_database;'\" postgres) = t",
        user => root,
        timeout => 60,
      }
    }

    default: {
      fail "postgresql 8.3 not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
