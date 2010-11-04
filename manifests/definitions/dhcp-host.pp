define dhcp::host($ensure=present,$mac,$subnet,$fixed_address=false) {
  include dhcp::variables
  common::concatfilepart {$name:
    ensure => $ensure,
    notify => Service["dhcpd"],
    file   => "${dhcp::variables::config_dir}/hosts.d/${subnet}.conf",
    require => Dhcp::Subnet[$subnet],
    content => template("dhcp/host.conf.erb"),
  }
}
