class os::ubuntu-gutsy inherits ubuntu {

  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }

  apt::sources_list {"ubuntu-gutsy.sources":
    source => "puppet:///os/etc/apt/sources.list.d/ubuntu-gutsy.sources.list",
  }

  apt::sources_list {"c2c-gutsy.sources":
    source  => "puppet:///os/etc/apt/sources.list.d/c2c-gutsy.sources.list",
  }

  apt::key {"5C662D02":
    source  => "http://dev.camptocamp.com/packages/pub.key",
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
