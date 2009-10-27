class c2c::collectd-debian inherits collectd {
  os::backported_package {"collectd":
    install     => false,
    ensure      => present,
  }
  Package["collectd"] {
    require => Os::Backported_package["collectd"],
    ensure => present,
  }
}
