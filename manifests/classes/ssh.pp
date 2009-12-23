class monitoring::ssh {

  monitoring::check { "Process: sshd":
    codename => "check_sshd_process",
    command  => "check_procs",
    options  => "-w 1: -c 1: -C sshd",
  }

  # monitor ssh service from nagios server
  monitoring::check { "SSH service":
    codename => "check_ssh_service",
    command  => "check_ssh",
    options  => '$HOSTNAME$',
    remote   => true,
  }

  monitoring::check { "legacy ssh service check":
    ensure   => absent,
    codename => "check_ssh!22",
  }
}
