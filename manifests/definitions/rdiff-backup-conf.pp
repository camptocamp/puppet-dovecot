define rdiff-backup::conf ($ensure=present, $enable=true, $version, $source, $destination, $args, $retention) {

  file {"/etc/rdiff-backup.d/${name}.conf":
    ensure  => $ensure,
    content => template("rdiff-backup/hostconfig.erb"),
    require => File["/etc/rdiff-backup.d"],
  }

}
