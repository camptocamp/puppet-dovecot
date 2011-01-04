define openvpn::server::config($ensure=present,
    $source=false,
    $content=false,
    $on_boot=true
    ) {

  if (!$content and !$source ) {
    fail "Please provide either \$source or \$content for $name"
  }

  if ($content and $source) {
    fail "Please provide \$source OR \$content for $name"
  }

  include openvpn::params

  file {"${openvpn::params::config_srv_available}/${name}.conf":
    ensure => $ensure,
    notify => Service["openvpn"],
    owner  => root,
    group  => root,
    mode   => 0644,
    require => Package["openvpn"],
  }

  if $content {
    File["${openvpn::params::config_srv_available}/${name}.conf"] {
      content => $content,
    }
  }

  if $source {
    File["${openvpn::params::config_srv_available}/${name}.conf"] {
      source => $source,
    }
  }

  file {"${openvpn::params::base_config_dir}/${name}.conf":
    notify => Service["openvpn"],
  }


  if $on_boot {
    File["${openvpn::params::base_config_dir}/${name}.conf"] {
      ensure => "${openvpn::params::config_srv_available}/${name}.conf",
      owner  => root,
      group  => root,
      mode   => 0644,
    }
  } else {
    File["${openvpn::params::base_config_dir}/${name}.conf"] {
      ensure => absent,
    }
  }

}
