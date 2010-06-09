class ssh {
  package { "ssh":
    ensure => installed
  }

  service { "ssh":
    ensure => running,
    hasrestart => true,
    pattern => "/usr/sbin/sshd",
  }
}
