class monitoring::ntp {

  monitoring::check { "Process: ntpd":
    codename => "check_ntpd_process",
    command  => "check_procs",
    options  => "-p 1 -w 1:1 -c 1:1 -C ntpd",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

  # every epnet router is an NTP server
  $ntp_server = regsubst($ipaddress, '[0-9]+$', '1')

  monitoring::check { "NTP Offset":
    codename => "check_ntp_offset",
    command  => $lsbdistcodename ? {
      /^Nahant/ => "check_ntp",
      default   => "check_ntp_time",
    },
    options  => "-H ${ntp_server}",
    interval => 120,
    retry    => 30,
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-ntp",
      default => false,
    },
  }
}
