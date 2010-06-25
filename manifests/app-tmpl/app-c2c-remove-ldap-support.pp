class app-c2c-remove-ldap-support {

  package {["libpam-ldap","libnss-ldap","ldap-utils","nscd"]:
    ensure => purged,
    notify => Exec["removed old nsswitch.conf"],
  }

  exec {"removed old nsswitch.conf":
    command     => "rm /etc/nsswitch.conf",
    onlyif      => "test -f /etc/nsswitch.conf",
    refreshonly => true,
  }

  file{"/etc/nsswitch.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    replace => false,
    source  => "/usr/share/base-files/nsswitch.conf",
    require => [ 
      Exec["removed old nsswitch.conf"], 
      Package["libpam-ldap"], 
      Package["libnss-ldap"], 
      Package["ldap-utils"],
      Package["nscd"]
    ],
  }

}
