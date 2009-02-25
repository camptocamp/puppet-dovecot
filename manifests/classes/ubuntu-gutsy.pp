class os::ubuntu-gutsy inherits ubuntu {

  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }

  file { "/etc/apt/sources.list.d/ubuntu-gutsy.sources.list":
    mode   => 644,
    source => "puppet:///os/etc/apt/sources.list.d/ubuntu-gutsy.sources.list",
    before => Exec["apt-get_update"],
    notify  => Exec["apt-get_update"],
  }

  file { "/etc/apt/sources.list.d/c2c-gutsy.sources.list":
    mode    => 644,
    source  => "puppet:///os/etc/apt/sources.list.d/c2c-gutsy.sources.list",
    before  => Exec["apt-get_update"],
    notify  => Exec["apt-get_update"],
    #require => Class["workstation::apt-proxy"],
  }

  os::apt_key_add { c2c-gutsy-key:
    source  => "http://dev.camptocamp.com/packages/pub.key",
    keyid   => "5C662D02",
    notify  => Exec["apt-get_update"],
  }

  # Timezone
  file { "/etc/localtime":
    ensure => present,
    source => "file:///usr/share/zoneinfo/Europe/Zurich",
  }

  # Umask, etc.
  file { "/etc/profile":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///os/etc/profile-gutsy",
  }

  file { "/etc/timezone":
    ensure  => present,
    content => "Europe/Zurich",
  }

  # Kernel
  file { "/etc/modules":
    ensure => present,
  }
}
