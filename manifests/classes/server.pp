class syslog-ng::server inherits syslog-ng {
  package {"logrotate":
    ensure => installed,
  }

  File["/etc/syslog-ng/syslog-ng.conf"] {
    ensure  => present,
    content => template("syslog-ng/syslog-ng.server-options.conf.erb",
      "syslog-ng/syslog-ng.debian.conf.erb",
      "syslog-ng/syslog-ng.server-sourcedest.conf.erb"),
  }

  # Log repository
  file {"/srv/syslog":
    ensure  => directory,
  }

  file {"/srv/syslog/logs":
    ensure  => directory,
    require => File["/srv/syslog"],
  }

  # Log rotation
  file {"/etc/logrotate.d/logserver":
    ensure  => present,
    content => template("syslog-ng/logserver.logrotate.erb"),
    require => Package["logrotate"],
  }
}
