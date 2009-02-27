class apt {
  file{"/etc/apt/apt.conf.d/10periodic":
    ensure => present,
    source => "puppet:///apt/10periodic",
  }
}
