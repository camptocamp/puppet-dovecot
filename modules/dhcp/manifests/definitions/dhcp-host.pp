/*

= Definition: dhcp::host
Create dhcp configuration for a host

Arguments:
 *$mac*:           host MAC address (mandatory)
 *$subnet*:        subnet in which we want to add this host
 *$fixed_address*: host fixed address (if not set, takes $name)

*/
define dhcp::host($ensure=present,$mac,$subnet,$fixed_address=false) {
  include dhcp::params
  common::concatfilepart {"dhcp.host.$name":
    ensure => $ensure,
    notify => Service["dhcpd"],
    file   => "${dhcp::params::config_dir}/hosts.d/${subnet}.conf",
    content => template("dhcp/host.conf.erb"),
  }
}
