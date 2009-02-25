class os::debian-sarge inherits debian {
  tidy { "/etc/apt/sources.list":
    age => '0s'
  }

  file { "/etc/apt/sources.list.d/sarge.list":
    mode   => 644,
    source => "puppet:///os/etc/apt/sources.list/sources.list-debian-sarge",
    before => Exec["apt-get_update"],
  }

  file { "/etc/apt/sources.list.d/c2c.list":
    mode   => 644,
    source => "puppet:///os/etc/apt/sources.list/sources.list-c2c-sarge",
    before => Exec["apt-get_update"],
  }

  os::apt_key_add { c2c-key:
    source  => "http://dev.camptocamp.com/packages/pub.key",
    keyid   => "5C662D02",
    before  => Exec["apt-get_update"],
  }
}
