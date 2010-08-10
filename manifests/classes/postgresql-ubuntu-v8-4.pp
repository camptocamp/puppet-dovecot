/*

==Class: postgresql::ubuntu::v8-4

Parameters:
 $postgresql_data_dir:
    set the data directory path, which is used to store all the databases

Requires:
 - Class["apt::preferences"]

*/
class postgresql::ubuntu::v8-4 inherits postgresql::ubuntu::base {

  $data_dir = $postgresql_data_dir ? {
    "" => "/var/lib/postgresql",
    default => $postgresql_data_dir,
  }

  case $lsbdistcodename {
    "lucid" : {
      package {[
        "libpq-dev",
        "libpq5",
        "postgresql-client-8.4",
        "postgresql-common",
        "postgresql-client-common",
        "postgresql-contrib-8.4"
        ]:
        ensure  => present,
      }
  
      Package["postgresql"] {
        name => "postgresql-8.4",
      }

      Service["postgresql"] {
        name => "postgresql-8.4"
      }
   
      # re-create the cluster in UTF8
      exec {"pg_createcluster in utf8" : 
        command => "pg_dropcluster --stop 8.4 main && pg_createcluster -e UTF8 -d ${data_dir}/8.4/main --start 8.4 main",
        onlyif => "test \$(su -c \"psql -tA -c 'SELECT count(*)=3 AND min(encoding)=0 AND max(encoding)=0 FROM pg_catalog.pg_database;'\" postgres) = t",
        user => root,
        timeout => 60,
      }
    }

    default: {
      fail "postgresql 8.4 not available for ${operatingsystem}/${lsbdistcodename}"
    }
  }
}
