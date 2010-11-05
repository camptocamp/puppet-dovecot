/*

= Class: dhcp::server
Simple OS wrapper. Include this to install a dhcp server on your host.

Requires:
  module "common": git://github.com/camptocamp/puppet-common.git

Required arguments:
  *$dhcpd_domain_name*: domain-name option
  *$dhcpd_dns_servers*: domain-name-servers option

facultative argument:
  *$dhcpd_ddns_update*: ddns-update-style option
  *$dhcpd_ddns_authoritative*: set it if you want that your DHCP server is authoritative

Example:
node "dhcp.toto.ltd" {
  $dhcpd_domain_name = 'toto.ltd'
  $dhcpd_dns_servers = '192.168.21.1'
  include dhcp::server
  
  dhcp::subnet {"192.168.20.0":
    ensure => present,
    bcast => "192.168.20.255",
    dns   => "192.168.21.1, 10.26.22.1",
    other_opt => ['filename "pxelinux.0";', 'next-server 192.168.10.1;'],
    inc   => true,
  }

  dhcp::host {"titi-eth0":
    ensure => present,
    mac    => "0e:18:fa:fe:d9:00",
    subnet => "192.168.20.0",
    fixed_address => "192.168.10.52",
  }
}
*/
class dhcp {
  case $operatingsystem {
    Debian: { include dhcp::server::debian }
  }
}
