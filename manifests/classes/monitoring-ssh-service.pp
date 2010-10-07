class monitoring::ssh::service {
  monitoring::check { "SSH service":
    codename => "check_ssh_service",
    command  => "check_ssh",
    options  => $fqdn,
    type     => "remote",
    server   => $nagios_nsca_server,
  }
}
