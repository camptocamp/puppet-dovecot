class c2c::openerp-backups {
  file {"/usr/local/bin/smb-backup.sh":
    ensure  => present,
    owner   => root,
    group   => root,
    source  => "puppet:///c2c/usr/local/bin/smb-backup.sh",
    mode    => 0755,
  }
}
