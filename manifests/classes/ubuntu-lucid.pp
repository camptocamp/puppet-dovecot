class os::ubuntu-lucid inherits ubuntu {
  # CLEANING
  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }
}
