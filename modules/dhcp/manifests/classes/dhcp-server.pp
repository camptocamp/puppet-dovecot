/*

= Class: dhcp::server
Simple OS wrapper. Include this to install a dhcp server on your host.

Requires:
  module "common": git://github.com/camptocamp/puppet-common.git

facultative argument:
  *$dhcpd_ddns_update*        : ddns-update-style option (default to none)
  *$dhcpd_authoritative* : set it if you want that your DHCP server is authoritative (default to no)
  *$dhcpd_opts*               : any other DHCPD valid options

Example:
node "dhcp.toto.ltd" {
  $dhcpd_opts = ['domain-name "toto.ltd"', "domain-name-servers 192.168.21.1"]
  include dhcp::server
  
  dhcp::subnet {"10.27.20.0":
    ensure     => present,
    broadcast  => "10.27.20.255",
    other_opts => ['filename "pxelinux.0";', 'next-server 10.27.10.1;'],
  }

  dhcp::host {"titi-eth0":
    ensure => present,
    mac    => "0e:18:fa:fe:d9:00",
    subnet => "10.27.20.0",
    fixed_address => "10.27.10.52",
  }
}
*/
class dhcp {
  case $operatingsystem {
    Debian: { include dhcp::server::debian }
  }
}
