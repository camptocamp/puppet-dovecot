define c2c::smb-backup($ensure=present,
                           $user,
                           $password,
                           $server,
                           $schema,
                           $hour=3,
                           $minute=0) {
  cron { "$name":
    command => "/usr/local/bin/smb-backup.sh $user $password $server $schema",
    user    => "root",
    hour    => $hour,
    minute  => $minute,
    require => [Package["smbclient"],File["/usr/local/bin/smb-backup.sh"]],
    ensure  => $ensure,
  }

}
