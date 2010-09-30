class ssh {
  case $operatingsystem {
    /RedHat|CentOS/: {
      package { "openssh":
        ensure => installed,
        alias  => "ssh",
      }
    }
    /Debian|Ubuntu/: {
      package { "ssh":
        ensure => installed
      }
    }
  }

  service { "ssh":
    ensure     => running,
    hasrestart => true,
    pattern    => "/usr/sbin/sshd",
    require    => Package["ssh"],
  }
}
