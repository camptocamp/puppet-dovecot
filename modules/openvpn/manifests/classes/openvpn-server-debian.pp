class openvpn::server::debian inherits openvpn::server::base {

  augeas {"set autostart for openvpn":
    changes => "set /files/etc/default/openvpn/AUTOSTART all",
    notify  => Service["openvpn"],
    require => Package["openvpn"],
  }

}
