class syslog-ng {
  package {"syslog-ng":
    ensure => installed,
  }

  service {"syslog-ng":
    ensure    => running,
    subscribe => File["/etc/syslog-ng/syslog-ng.conf"],
    require   => Package["syslog-ng"],
  }

  file {"/etc/syslog-ng/syslog-ng.conf":
    ensure  => present,
    content => template("syslog-ng/syslog-ng.client-options.conf.erb",
      "syslog-ng/syslog-ng.debian.conf.erb",
      "syslog-ng/syslog-ng.client-sourcedest.conf.erb"),
    require => Package["syslog-ng"],
    notify  => Service["syslog-ng"],
  }
}
