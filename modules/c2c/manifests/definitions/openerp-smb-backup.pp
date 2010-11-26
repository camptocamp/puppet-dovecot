define c2c::smb-backup($ensure=present,
                           $user,
                           $password,
                           $server,
                           $schema,
                           domain=false,
                           $hour=3,
                           $minute=0) {
  cron { "$name":
    command => "/usr/local/bin/smb-backup.sh",
    user    => "root",
    hour    => $hour,
    minute  => $minute,
    require => [Package["smbclient"],File["/usr/local/bin/smb-backup.sh"]],
    ensure  => $ensure,
  }

  file {"/usr/local/bin/smb-backup.sh":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0700,
    content => template('c2c/smb-backup.sh.erb'),
  }

}
