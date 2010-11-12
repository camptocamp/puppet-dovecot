class openvpn::params {

  $base_config_dir = $operatingsystem? {
    Debian => "/etc/openvpn",
  }

  $config_srv_available = $operatingsystem? {
    Debian => "${base_config_dir}/server-available",
  }

  $server_ssl_dir = $operatingsystem? {
    Debian => "${base_config_dir}/ssl",
  }

  $server_log_dir = $operatingsystem? {
    Debian => "/var/log/openvpn",
  }
}
