class monitoring::at {

  monitoring::check { "Process: atd":
    codename => "check_at_process",
    command  => "check_procs",
    options  => "-p 1 -w 1:1 -c 1:1 -C atd",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
