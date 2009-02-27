class os::ubuntu-hardy inherits ubuntu {

  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
# CLEANING

  apt::sources_list {"ubuntu-gutsy.sources":
    ensure => absent,
  }
  
  apt::sources_list {"ubuntu-hardy.sources":
    ensure => absent,
  }

  apt::sources_list {"c2c-hardy.sources":
    ensure => absent,
  }

  apt::sources_list {"c2c-gutsy.sources":
    ensure => absent,
  }


  apt::sources_list {"ubuntu.sources":
    content => template("os/ubuntu.list.erb"),
  }

  apt::sources_list {"c2c.sources":
    content => template("os/c2c.list.erb"),
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
