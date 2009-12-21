class monitoring::collectd {

  monitoring::check { "Process: collectd":
    codename => "check_collectd_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C collectd",
  }
}
