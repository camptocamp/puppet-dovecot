class apt {
  Package {
    require => Exec["apt-get_update"]
  }

  # ensure only files managed by puppet be present in this directory.
  file { "/etc/apt/sources.list.d":
    ensure  => directory,
    source  => "puppet:///apt/empty/",
    recurse => true,
    purge   => true,
    force   => true,
    ignore  => ".placeholder",
  }

  apt::conf {"10periodic":
    ensure => present,
    source => "puppet:///apt/10periodic",
  }

  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true,
  }
}
