import "classes/*.pp"
import "definitions/*.pp"

/*

== Class lighttpd

Install and create puppet resources for lighttpd.

Example:

node "foo.bar" {
  $sudo_lighttpd_admin_user = "foo"

  include lighttpd
  include lighttpd::administration

  lighttpd::vhost {"$fqdn":
    ensure => present,
    aliases => ["bar.foo"],
  }
}

*/
class lighttpd {
  case $operatingsystem {
    /Debian|Ubuntu/: { include lighttpd::debian }
    /RedHat|CentOS/: { include lighttpd::redhat }
    default: { fail "No instruction for $operatingsystem" }
  }
}
