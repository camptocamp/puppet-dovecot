class monitoring::at {

  monitoring::check { "Process: atd":
    codename => "check_at_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C atd",
    package  => $operatingsystem ?{
      CentOS => "nagios-plugins-procs",
      RedHat => "nagios-plugins-procs",
      default => false
    }
  }
}
