define postgresql::cluster (
  $ensure,
  $clustername,
  $version,
  $uid = "postgres",
  $gid = "postgres",
  $data_dir = "/var/lib/postgresql"
) {

  case $ensure {
    present: {

      file {$data_dir:
        ensure => directory,
        owner => "postgres",
        group => "postgres",
        mode => 755,
        require => [Package["postgresql"], User["postgres"]],
      }

      exec {"pg_createcluster --start -u $uid -g $gid -d ${data_dir}/${version}/${clustername} $version $clustername":
        unless => "pg_lsclusters -h | awk '{ print \$1,\$2; }' | egrep '^${version} ${clustername}\$'",
        require => File[$data_dir],
      }

    }

    absent: {
      exec {"pg_dropcluster --stop $version $clustername":
        onlyif => "pg_lsclusters -h | awk '{ print \$1,\$2,\$6; }' | egrep '^${version} ${clustername} ${data_dir}/${version}/${clustername}\$'",
      }
    }
  }
}
