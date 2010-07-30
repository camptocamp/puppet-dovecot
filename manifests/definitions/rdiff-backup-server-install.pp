define rdiff-backup::server::install ($ensure=present) {
  $version = "rdiff-backup-${name}"
  $url = "http://mirror.lihnidos.org/GNU/savannah/rdiff-backup/${version}.tar.gz"

  if !defined($rdiff_backup_enable_mail) or ($rdiff_backup_enable_mail == 1) or ($rdiff_backup_enable_mail == "on") or ($rdiff_backup_enable_mail == "yes") or ($rdiff_backup_enable_mail == "true") {
    $rdiff_backup_enable_mail = 1
  } else {
    $rdiff_backup_enable_mail = 0
  }

  case $ensure {
    present: {

      common::archive::tar-gz{"/opt/rdiff-backup/${version}/.installed":
        source  => $url,
        target  => "/opt/rdiff-backup",
        notify  => Exec["install ${version}"],
        require => File["/opt/rdiff-backup"],
      }

      exec {"install ${version}":
        command     => "cd /opt/rdiff-backup/${version} && python setup.py install --prefix=/opt/rdiff-backup/${version}",
        unless      => "test -f /opt/rdiff-backup/${version}/bin/rdiff-backup",
        refreshonly => true,
        require     => Package["librsync-devel", "python-devel"],
      }
    }

    absent: {
      file{"/opt/rdiff-backup/${version}":
        ensure => absent,
        force => true,
      }
    }
  }
}
