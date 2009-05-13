define rdiff-backup::server::install ($ensure=present) {
  $version = "rdiff-backup-${name}"
  $url = "http://www.very-clever.com/download/nongnu/rdiff-backup/${version}.tar.gz"

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
