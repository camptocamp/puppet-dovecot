class os::ubuntu-hardy inherits ubuntu {

  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
# CLEANING
  file { "/etc/apt/sources.list.d/ubuntu-gutsy.sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
  file { "/etc/apt/sources.list.d/ubuntu-hardy.sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
  file { "/etc/apt/sources.list.d/c2c-hardy.sources.list":
    ensure => absent,
  }
  file { "/etc/apt/sources.list.d/c2c-gutsy.sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }


  file { "/etc/apt/sources.list.d/ubuntu.sources.list":
    mode   => 644,
    content => template("os/ubuntu.list.erb"),
    before => Exec["apt-get_update"],
    notify  => Exec["apt-get_update"],
  }

  file { "/etc/apt/sources.list.d/c2c.sources.list":
    mode    => 644,
    content => template("os/c2c.list.erb"),
    before  => Exec["apt-get_update"],
    notify  => Exec["apt-get_update"],
  }

  os::apt_key_add { c2c-hardy-key:
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
    source => "puppet:///os/etc/profile-hardy",
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
