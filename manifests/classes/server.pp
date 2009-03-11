class syslog::server inherits syslog {
  package {"logrotate":
    ensure => installed,
  }

  File["/etc/syslog-ng/syslog-ng.conf"] {
    ensure  => present,
    content => template("syslog/syslog-ng.server.conf.erb"),
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
    content => template("syslog/logserver.logrotate.erb"),
    require => Package["logrotate"],
  }
}
