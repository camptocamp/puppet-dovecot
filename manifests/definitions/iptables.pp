/*

== Definition: pacemaker::iptables

A helper which allows setting iptables rules for pacemaker.

Parameters:
- *$name*: the address or address block you want to allow heartbeat packets
  from.
- *$port*: the UDP port heartbeat listens on, defaults to 691.

Example usage:

  pacemaker::iptables {"10.0.1.0/24": port => "1234" }
  pacemaker::iptables {["192.168.0.2", "192.168.0.3"]: }

*/
define pacemaker::iptables ($port="691") {

  iptables { "allow pacemaker from $name on port $port":
    proto => "udp",
    dport => $port,
    source => $name,
    jump => "ACCEPT",
  }
}
