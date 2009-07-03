class c2c::skel {
  file { "/etc/skel/.bash_logout":
    source  => "puppet:///c2c/etc/skel/.bash_logout",
    ensure  => present,
  }

  file { "/etc/skel/.bash_profile":
    source  => "puppet:///c2c/etc/skel/.bash_profile",
    ensure  => present,
  }

  file { "/etc/skel/.bashrc":
    content => template("c2c/etc/skel/.bashrc"),
    ensure => present,
  }

  file { "/etc/skel/.screenrc":
    source  => "puppet:///c2c/etc/skel/.screenrc",
    ensure  => present,
  }
}
