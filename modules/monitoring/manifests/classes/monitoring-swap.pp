class monitoring::swap {

  monitoring::check { "Swap I/O":
    codename => "check_collectd_swapio",
    base     => "/usr/bin/",
    command  => "collectd-nagios",
    options  => "-s /var/run/collectd.sock -H $fqdn -n 'vmem/vmpage_io-swap' -w 10 -c 1000",
    type     => "passive",
    server   => $nagios_nsca_server,
    require  => Class["monitoring::collectd"],
  }
}
