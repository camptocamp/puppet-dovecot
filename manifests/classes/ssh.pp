class monitoring::ssh {

  monitoring::check { "Process: sshd":
    codename => "check_sshd_process",
    command  => "check_procs",
    options  => "-w 1: -c 1: -C sshd",
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

  # monitor ssh service from nagios server
  monitoring::check { "SSH service":
    codename => "check_ssh_service",
    command  => "check_ssh",
    options  => $fqdn,
    remote   => true,
  }
}
