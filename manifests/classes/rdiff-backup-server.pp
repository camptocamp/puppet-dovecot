class rdiff-backup::server {
  
  file {"/etc/rdiff-backup.d":
    ensure => directory,
    owner  => root,
    group  => root,
  }

  package {"librsync-dev":
    ensure => present,
  }

  file {"/opt/rdiff-backup":
    ensure => directory,
  }

  file {"/var/log/rdiff-backup":
    ensure => directory,
  }

  file {"/etc/multithreaded-rdiff-backup.conf":
    ensure => present,
    owner => root,
    group => root,
    content => template("rdiff-backup/mainconfig.erb"),
  }

  file {"/usr/local/sbin/multithreaded-rdiff-backup.py":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 755,
    source => "puppet:///rdiff-backup/usr/local/sbin/multithreaded-rdiff-backup.py",
  }
  
  # cron to start multi-thread script
  cron {"start multithreaded backup script":
    ensure  => present,
    command => "python /usr/local/sbin/multithreaded-rdiff-backup.py",
    minute  => "0",
    hour    => "1",
    user    => "root",
    require => File["puppet:///rdiff-backup/usr/local/sbin/multithreaded-rdiff-backup.py"],
  }

}
