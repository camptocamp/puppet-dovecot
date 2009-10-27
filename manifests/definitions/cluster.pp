define postgresql::cluster (
  $ensure,
  $version,
  $uid = "",
  $gid = "",
  $data_dir = "",
  $socket_dir = "",
  $log_dir = "",
  $locale = "",
  $encoding = "",
  $port = ""
) {

  case $ensure {
    present: {
      exec {"pg_createcluster $version $name":
        unless => "pg_lsclusters -h | awk '{ print \$1,\$2; }' | egrep '^${version} ${name}\$'",
      }
    }

    absent: {
      exec {"pg_dropcluster --stop $version $name":
        onlyif => "pg_lsclusters -h | awk '{ print \$1,\$2; }' | egrep '^${version} ${name}\$'",
      }
    }
  }
}
