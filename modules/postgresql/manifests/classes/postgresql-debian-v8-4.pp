/*

==Class: postgresql::debian::v8-4

Parameters:
 $postgresql_data_dir:
    set the data directory path, which is used to store all the databases

Requires:
 - Class["apt::preferences"]

*/
class postgresql::debian::v8-4 inherits postgresql::debian::base {

  $data_dir = $postgresql_data_dir ? {
    "" => "/var/lib/postgresql",
    default => $postgresql_data_dir,
  }

  if $lsbdistcodename == "lenny" {
    apt::preferences {[
      "libpq-dev",
      "libpq5",
      "postgresql-8.4",
      "postgresql-client-8.4",
      "postgresql-common", 
      "postgresql-client-common",
      "postgresql-contrib-8.4"
      ]:
      pin => "release a=${lsbdistcodename}-backports",
      priority => "1100"
    }
  }

  case $lsbdistcodename {
    lenny,squeeze : {
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
        start   => "/etc/init.d/postgresql start 8.4",
        status  => "/etc/init.d/postgresql status 8.4",
        stop    => "/etc/init.d/postgresql stop 8.4",
        restart => "/etc/init.d/postgresql restart 8.4",
        require => [Package["postgresql-common"], File["/etc/init.d/postgresql-8.4"]],
      }

      file {"/etc/init.d/postgresql-8.4":
        ensure  => absent,
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
