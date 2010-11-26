class app-levantis-dnag-openerp {
  package {"smbclient": }

  c2c::smb-backup {"backup to beosrv06":
    ensure => present,
    user   => "tinyerp",
    password => "Cam2camp2010",
    schema   => '//beosrv06/tiny_erp$/',
    server   => "10.100.0.15",
    domain   => "beodaz",
  }
}
