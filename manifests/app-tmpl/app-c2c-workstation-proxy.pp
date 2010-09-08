class app-c2c-workstation-proxy {
  file {"/etc/network/if-up.d/use_proxy":
    ensure => present,
    mode   => 0755,
    owner  => root,
    group  => root,
    source => "puppet:///modules/c2c/etc/network/if-up.d/use_proxy",
  }
}
