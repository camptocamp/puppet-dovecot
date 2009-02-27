class os::debian-sarge inherits debian {
  tidy { "/etc/apt/sources.list":
    age => '0s'
  }

  apt::sources_list {"sarge":
    source => "puppet:///os/etc/apt/sources.list/sources.list-debian-sarge",
  }

  apt::sources_list {"c2c":
    source => "puppet:///os/etc/apt/sources.list/sources.list-c2c-sarge",
  }

  apt::key {"5C662D02":
    source  => "http://dev.camptocamp.com/packages/pub.key",
  }
}
