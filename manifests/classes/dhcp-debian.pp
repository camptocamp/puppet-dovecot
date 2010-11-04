/*

= Class: dhcp::debian
Installs a dhcp server on debian system.

This class should not be included as is, please include "dhcp" instead.

*/
class dhcp::debian inherits dhcp::base {

  Common::Concatfilepart["00-base"] {
    content => $lsbdistcodename ? {
      squeeze => template('dhcp/dhcpd.conf.squeeze.erb'),
      lenny   => template('dhcp/dhcpd.conf.lenny.erb'),
    }
  }

  Service["dhcpd"] {
    pattern => $lsbdistcodename ? {
      squeeze => "/usr/sbin/dhcpd",
      lenny   => "/usr/sbin/dhcpd3",
    }
  }
}
