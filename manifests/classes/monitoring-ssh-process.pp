class monitoring::ssh::process {
  monitoring::check { "Process: sshd":
    codename => "check_sshd_process",
    command  => "check_procs",
    options  => "-p 1 -w 1: -c 1: -C sshd",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
