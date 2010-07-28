/*

== Class openvz::client

Simple wrapper: will include os-dependent class.
Those classes will configure some stuff inside an OVZ
container.

*/
class openvz::client {
  case $lsbdistid {
    Debian,Ubuntu: { include openvz::client::debian }
    default: { fail "Openvz not implemented for $lsbdistid"}
  }
}
