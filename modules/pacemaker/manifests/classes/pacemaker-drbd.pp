/*

== Class: pacemaker::drbd

Helper which includes the drbd::base class, but with service management
disabled.  This is useful if DRBD needs to be managed by heartbeat, but you
still want to benefit from the facilities provided in the drbd module.

Requires:
- drbd's puppet module

Example usage:
  include pacemaker::drbd

*/
class pacemaker::drbd inherits drbd::base {

  Service["drbd"] {
    ensure => undef,
    enable => false,
  }
}
