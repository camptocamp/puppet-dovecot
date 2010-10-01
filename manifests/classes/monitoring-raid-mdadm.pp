class monitoring::raid::mdadm {
  monitoring::check {"System: mdadm raid status":
    ensure   => present,
    codename => "check_mdadm",
    command  => "check_linux_raid",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem? {
      /RedHat|CentOS/ => "nagios-plugins-linux_raid",
      default         => false,
    }
  }
}
