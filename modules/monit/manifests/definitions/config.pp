define monit::config($ensure, $content = false, $source = false) {
  $filename = "/etc/monit/monitrc.d/puppet-${name}.conf"

  case $ensure {
    present: {
      if $source {
        file {$filename:
          ensure => present,
          source => $source,
          owner  => root,
          group  => root,
          mode   => 600,
          notify => Service["monit"],
          require => Package["monit"],
        }
      } else {
        if $content {
          file {$filename:
            ensure  => present,
            content => $content,
            owner   => root,
            group   => root,
            mode    => 600,
            notify  => Service["monit"],
            require => Package["monit"],
          }
        } else {
          file {$filename:
            ensure => present,
            owner   => root,
            group   => root,
            mode    => 600,
            notify  => Service["monit"],
            require => Package["monit"],
          }
        }
      }
    }

    absent: {
      file {"/etc/monit/monitrc.d/puppet-${name}.conf":
        ensure => absent,
        notify  => Service["monit"],
        require => Package["monit"],
      }
    }
  }
}
