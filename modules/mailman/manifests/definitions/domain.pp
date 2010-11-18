define mailman::domain ($ensure, $vhost, $urlpath="/cgi-bin/mailman/") {
  postfix-ng::transport {"${name}":
    ensure      => present,
    destination => "mailman:",
  }

  file {"/etc/mailman/mm_cfg.py":
    ensure => present,
    content => template("mailman/mm_cfg.py.erb"),
    require => Package["mailman"],
  }

  file {"/etc/mailman/apache.conf":
    ensure => present,
    content => template("mailman/apache.conf.erb"),
    require => Package["mailman"],
  }
}
