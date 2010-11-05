/*

= Definition: dhcp::subnet
Creates a subnet

Arguments:
 *$broadcast*   : subnet broadcast (mandatory)
 *$netmask*     : subnet netmask (if not set, takes eth0 netmask)
 *$routers*     : subnet routers (array)  (if not set, takes eth0 IP)
 *$subnet_mask* : netmask sent to dhcp guests (if not set, takes $netmask, or netmask_eth0)
 *$domain_name* : subnet domain name (if not set, takes server domain)
 *$other_opts*  : any other DHCPD option, as an array

Example:

node "dhcp.domain.ltd" {
  $dhcpd_domain_name = 'domain.ltd'
  $dhcpd_dns_servers = '10.27.21.1, 10.26.21.1'
  include dhcp

  dhcp::subnet {"10.27.20.0":
    ensure     => present,
    broadcast  => "10.27.20.255",
    other_opts => ['filename "pxelinux.0";', 'next-server 10.27.10.1;'],
  }
}
*/
define dhcp::subnet(
  $ensure=present,
  $broadcast,
  $netmask=false,
  $routers=false,
  $subnet_mask=false,
  $domain_name=false,
  $other_opts=false) {
  include dhcp::params

  $to_include = "${dhcp::params::config_dir}/hosts.d/${name}.conf"

  file {"${dhcp::params::config_dir}/subnets/${name}.conf":
    ensure => $ensure,
    owner  => root,
    group  => root,
    content => template("dhcp/subnet.conf.erb"),
    notify  => Service["dhcpd"],
  }
  
  common::concatfilepart {"dhcp.${name}":
    file => "${dhcp::params::config_dir}/dhcpd.conf",
    ensure => $ensure,
    content => "include \"${dhcp::params::config_dir}/subnets/${name}.conf\";\n",
  }

  common::concatfilepart {"00.dhcp.${name}.base":
    file   => $to_include,
    ensure => $ensure,
    content => "# File managed by puppet\n",
  }
}
