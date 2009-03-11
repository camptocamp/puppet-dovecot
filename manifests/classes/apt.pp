class apt {
  Package {
    require => Exec["apt-get_update"]
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
