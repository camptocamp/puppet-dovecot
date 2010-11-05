/*

= Class: dhcp::variables
Do NOT include this class - it won't do anything.
Set variables for names and paths

*/
class dhcp::variables {
  case $operatingsystem {
    Debian: {
      $config_dir = $lsbdistcodename? {
        lenny   => "/etc/dhcp3",
        squeeze => "/etc/dhcp",
      }

      $srv_dhcpd = $lsbdistcodename? {
        lenny   => "dhcp3-server",
        squeeze => "isc-dhcp-server",
      }
    }
  }
}
