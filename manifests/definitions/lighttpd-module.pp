/*

== Definition: lighttpd::module
Arguments:
  *$ensure*: ensures module's present or not

Example:
node "foo.bar" {
  include lighttpd

  lighttpd::module{"fastcgi":
    ensure => present,
  }
}

*/
define lighttpd::module(
  $ensure=present
  ) {
  
  case $ensure {
    present: {
      exec {"enable ${name}":
        command => "lighty-enable-mod ${name}",
        unless  => "lighty-enable-mod - | egrep 'Already enabled modules:.*${name}'",
        notify  => Exec["reload-lighttpd"],
        require => Class["lighttpd"],
      }
    }
    absent: {
      exec {"disble ${name}":
        command => "lighty-disable-mod ${name}",
        onlyif  => "lighty-disable-mod - | egrep 'Already enabled modules:.*${name}'",
        notify  => Exec["reload-lighttpd"],
        require => Class["lighttpd"],
      }
    }
    default: { faile "unknown \$ensure $ensure for $name" }
  }
}
