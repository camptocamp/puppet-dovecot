/*

== Class openvz::guest::notty


Functions:
- Disable tty inside container - they are useless, and create useless logs.

*/
class openvz::guest::notty {

  exec {"reload init":
    command     => "kill -HUP 1",
    refreshonly => true,
  }


  exec {"remove tty* from inittab":
    command => "sed -ri 's#^[1-6].+respawn:/sbin/getty.+$##' /etc/inittab",
    onlyif  => "egrep '^[1-6].+respawn:/sbin/getty.+$' /etc/inittab",
    notify  => Exec["reload init"]
  }
}
