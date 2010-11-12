class stunnel4::debian {
  package {"stunnel4":
    ensure => present,
  }

  file {"/etc/stunnel/stunnel.conf":
    ensure => absent,
    require => Package["stunnel4"],
  }
  
  service {"stunnel4":
    ensure  => running,
    enable  => true,
    require => [Package["stunnel4"], Augeas["enable stunnel4"], File["/etc/stunnel/stunnel.conf"]],
  }

  augeas {"enable stunnel4":
    context => "/files/etc/default/stunnel4",
    changes => "set ENABLED 1",
    require => Package["stunnel4"],
  }
}
