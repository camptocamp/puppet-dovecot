class rdiff-backup::server::v1-3-0 inherits rdiff-backup::server {
  $version = "rdiff-backup-1.3.0"
  $url = "http://www.very-clever.com/download/nongnu/rdiff-backup/${version}.tar.gz"

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
