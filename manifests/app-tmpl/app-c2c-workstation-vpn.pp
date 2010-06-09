class app-c2c-workstation-vpn {

  package {[
    "vpnc",
    "openvpn",
    "network-manager-openvpn",
    "network-manager-vpnc"]:
    ensure => present,
  }

  file {"/etc/openvpn":
    ensure => directory,
    mode => 755,
    purge => true,
    force => true,
    recurse => true,
    require => Package["openvpn"],
  }

  file {"/etc/openvpn/camptocamp":
    ensure => directory,
    mode => 775,
    require => File["/etc/openvpn"],
  }

  file {"/etc/openvpn/camptocamp/ca.crt":
    ensure => present,
    mode => 644,
    source => "puppet:///c2c/etc/openvpn/camptocamp/ca.crt",
    require => File["/etc/openvpn/camptocamp"],
  }

  file {"/etc/openvpn/camptocamp/ta.key":
    ensure => present,
    mode => 644,
    source => "puppet:///c2c/etc/openvpn/camptocamp/ta.key",
    require => File["/etc/openvpn/camptocamp"],
  }
  
  # allow to use vpn without networkmanager
  package {"resolvconf": ensure => purged, }

  file {"/etc/openvpn/scripts":
    ensure => directory,
    mode => 755,
    require => Package["resolvconf"],
  }

  file {"/etc/openvpn/scripts/c2c.conf":
    ensure => present,
    mode => 644,
    source => "puppet:///c2c/etc/openvpn/scripts/c2c.ovpn",
    require => File["/etc/openvpn/scripts"],
  }

  file {"/etc/openvpn/scripts/up.sh":
    ensure => present,
    mode => 744,
    source => "puppet:///c2c/etc/openvpn/scripts/up.sh",
    require => File["/etc/openvpn/scripts"],
  }

  file {"/etc/openvpn/scripts/down.sh":
    ensure => present,
    mode => 744,
    source => "puppet:///c2c/etc/openvpn/scripts/down.sh",
    require => File["/etc/openvpn/scripts"],
  }

}
