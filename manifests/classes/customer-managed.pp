class c2c::customer-managed {
  File["/etc/sudoers"] {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 440,
    source => "puppet:///c2c/etc/sudoers.managed-customers",
  }
}
