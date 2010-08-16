class monitoring::drbd {

  file { "/opt/nagios-plugins/check_drbd":
    mode    => 0755,
    owner   => "root",
    group   => "root",
    source  => "puppet:///drbd/check_drbd",
    before  => Monitoring::Check["DRBD"],
  }

  monitoring::check { "DRBD":
    codename => "check_drbd_status",
    command  => "check_drbd",
    options  => "/proc/drbd",
    base     => '$USER2$/',
    type     => "passive",
    server   => $nagios_nsca_server,
  }
}
