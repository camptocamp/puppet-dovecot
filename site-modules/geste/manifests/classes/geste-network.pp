class geste::network {
  file {"/etc/network/interfaces":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("geste/interfaces.erb"),
  }

  file {"/etc/resolv.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("geste/resolv.conf.erb"),
  }
}
