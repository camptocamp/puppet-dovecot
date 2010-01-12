class syslog-ng {

  case $operatingsystem {
    Debian: { $ostmpl = "syslog-ng/syslog-ng.debian.conf.erb" }
    RedHat:  { $ostmpl = "syslog-ng/syslog-ng.redhat.conf.erb" }
    default: { fail "Unsupported operatingsystem ${operatingsystem}" }
  }

  package {"syslog-ng":
    ensure => installed,
  }

  service {"syslog-ng":
    ensure    => running,
    enable    => true,
    subscribe => File["/etc/syslog-ng/syslog-ng.conf"],
    require   => Package["syslog-ng"],
  }

  file {"/etc/syslog-ng/syslog-ng.conf":
    ensure  => present,
    content => template(
      "syslog-ng/syslog-ng.header.conf.erb",
      "syslog-ng/syslog-ng.client-options.conf.erb",
      $ostmpl,
      "syslog-ng/syslog-ng.client-sourcedest.conf.erb"),
    require => Package["syslog-ng"],
    notify  => Service["syslog-ng"],
  }
}
