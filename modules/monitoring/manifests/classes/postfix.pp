class monitoring::postfix {

  monitoring::check { "Process: postfix":
    codename => "check_postfix_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C master",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
