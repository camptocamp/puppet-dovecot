class samba::server inherits samba::common {
  package { "samba":
    ensure => installed,
  }

  service { "samba":
    ensure  => running,
    pattern => smbd,
    restart => "/etc/init.d/samba reload",
    require => Package[samba],
  }

  file { "/etc/samba":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 755,
    require => Package[samba],
  }
}
