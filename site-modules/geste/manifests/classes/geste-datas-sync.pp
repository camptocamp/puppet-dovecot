class geste::datas-sync {
  if $geste_master {

    package {"lockfile-progs":
      ensure => latest,
    }

    file {"/usr/local/sbin/sync-datas":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0700,
      source => "puppet:///modules/geste/sync-datas",
    }

    file {"/var/log/sync-datas":
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => 0755,
    }

    tidy {"/var/log/sync-datas/":
      age     => "30d",
      recurse => true,
      matches => 'sync-*.log',
    }

    cron {"sync datas to slave":
      ensure => present,
      command => "/usr/local/sbin/sync-datas",
      hour    => "1",
      minute  => ip_to_cron(),
      require => File["/usr/local/sbin/sync-datas"],
    }
  }
}
