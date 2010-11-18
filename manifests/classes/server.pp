class syslog-ng::server inherits syslog-ng {
  package {"logrotate":
    ensure => installed,
  }

  File["/etc/syslog-ng/syslog-ng.conf"] {
    ensure  => present,
    content => template(
      "syslog-ng/syslog-ng.header.conf.erb",
      "syslog-ng/syslog-ng.server-options.conf.erb",
      $ostmpl,
      "syslog-ng/syslog-ng.server-sourcedest.conf.erb"),
  }

  # Log repository
  file {"/srv/syslog":
    ensure  => directory,
    seltype => "var_t",
  }

  file {"/srv/syslog/logs":
    ensure  => directory,
    seltype => "var_log_t",
    require => File["/srv/syslog"],
  }

  # Log rotation
  file {"/etc/logrotate.d/logserver":
    ensure  => present,
    content => template("syslog-ng/logserver.logrotate.erb"),
    require => Package["logrotate"],
  }
}
