class monit {
  package {"monit":
    ensure => present
  }

  service {"monit":
    ensure  => running,
    require => Package["monit"]
  }

  file {"/etc/default/monit":
    ensure => present,
    source => "puppet:///monit/monit.default",
    require => Package["monit"],
  }

  file {"/etc/monit/monitrc":
    ensure => present,
    source => "puppet:///monit/monitrc",
    owner  => root,
    group  => root,
    mode   => 600,
    require => Package["monit"],
  }

  file {"/etc/monit/monitrc.d":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 700,
    require => Package["monit"],
  }

  # Monit doesn't start when monitrc.d/ is empty
  monit::config{"default":
    ensure  => present,
    content => "",
  }
}
