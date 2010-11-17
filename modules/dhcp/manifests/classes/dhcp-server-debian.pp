/*

= Class: dhcp::server::debian
Installs a dhcp server on debian system.

This class should not be included as is, please include "dhcp::server" instead.

*/
class dhcp::server::debian inherits dhcp::server::base {

  Common::Concatfilepart["00.dhcp.server.base"] {
    content => template('dhcp/dhcpd.conf.debian.erb'),
  }

  Service["dhcpd"] {
    pattern => $lsbdistcodename ? {
      squeeze => "/usr/sbin/dhcpd",
      lenny   => "/usr/sbin/dhcpd3",
    }
  }
}
