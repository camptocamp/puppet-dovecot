class rdiff-backup::client {
  if defined (Package["rdiff-backup"]) {
    notice "package rdiff-backup is already defined"
  } else {
    package {"rdiff-backup":
      ensure => present,
    }
  }
}
