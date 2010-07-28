/*

== Class: openvz::server

Simple wrapper. Include os-dependent class.
Those classes will activate repositories, install packages,
and maybe configure some stuff on the server

*/
class openvz::server {
  case $lsbdistid {
    CentOS, RedHat: { include openvz::server::rhel}
    default: { fail "Openvz not implemented for $lsbdistid"}
  }
}
