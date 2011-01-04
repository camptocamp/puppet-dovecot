class openvpn::server::base {
  include openvpn::params
  package {"openvpn":
    ensure => present,
  }
  
  service {"openvpn":
    ensure  => running,
    enable  => true,
    require => Package["openvpn"],
  }

  file {"${openvpn::params::config_srv_available}":
    require => Package["openvpn"],
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
  }

  file {"${openvpn::params::server_log_dir}":
    require => Package["openvpn"],
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
  }

  file {"${openvpn::params::server_ssl_dir}":
    require => Package["openvpn"],
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
  }
}
