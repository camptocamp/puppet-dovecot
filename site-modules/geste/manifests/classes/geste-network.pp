class geste::network {
  file {"/etc/network/interfaces":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => $geste_master? {
      true  => "puppet:///modules/geste/network/interfaces.master",
      false => "puppet:///modules/geste/network/interfaces.slave",
    }
  }

  file {"/etc/resolv.conf":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/geste/network/resolv.conf",
  }
}
