class apt {
  apt::confg {"10periodic":
    ensure => present,
    source => "puppet:///apt/10periodic",
  }

  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true,
  }
}
