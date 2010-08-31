class os::ubuntu-hardy inherits ubuntu {
  # CLEANING
  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
  apt::sources_list {"ubuntu-gutsy.sources":
    ensure => absent,
  }
  apt::sources_list {"c2c-gutsy.sources":
    ensure => absent,
  }
  apt::sources_list {"ubuntu-hardy.sources":
    ensure => absent,
  }
  apt::sources_list {"c2c-hardy.sources":
    ensure => absent,
  }
}
