/*

== Class: pacemaker::apache

Helper which includes the apache module, but with service management disabled.
This is useful if your apache server needs to be managed by heartbeat, but you
still want to benefit from the facilities provided in the apache module.

Requires:
- apache's puppet module

Example usage:
  include pacemaker::apache
  apache::vhost {$fqdn: ensure => present }

*/
class pacemaker::apache {

  case $operatingsystem {

    RedHat: {
      include pacemaker::apache-redhat

      class pacemaker::apache-redhat inherits apache::redhat {

        Service["httpd"] {
          ensure => undef,
          enable => false,
        }
      }
    }

    Debian: {
      include pacemaker::apache-debian

      class pacemaker::apache-debian inherits apache::debian {

        Service["apache2"] {
          ensure => undef,
          enable => false,
        }
      }
    }
  }
}

/*

== Class: pacemaker::apache::ssl

Companion class for pacemaker::apache

Requires:
- apache's puppet module

Example usage:
  include pacemaker::apache
  include pacemaker::apache::ssl
  apache::vhost {$fqdn: ensure => present }

*/
class pacemaker::apache::ssl {

  case $operatingsystem {

    RedHat: {
      include apache::ssl::redhat
    }

    Debian: {
      include apache::ssl::debian
    }
  }
}
