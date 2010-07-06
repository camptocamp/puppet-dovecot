class monitoring::ntp {

  monitoring::check { "Process: ntpd":
    codename => "check_ntpd_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C ntpd",
    package  => $operatingsystem ?{
      CentOS => "nagios-plugins-procs",
      default => false
    }
  }

  # every epnet router is an NTP server
  $ntp_server = regsubst($ipaddress, '[0-9]+$', '1')

  monitoring::check { "NTP Offset":
    codename => "check_ntp_offset",
    command  => $lsbdistcodename ? {
      #TODO /^Nahant/ => "check_ntp",
      "NahantUpdate4" => "check_ntp",
      "NahantUpdate5" => "check_ntp",
      "NahantUpdate6" => "check_ntp",
      "NahantUpdate7" => "check_ntp",
      "NahantUpdate8" => "check_ntp",
      default   => "check_ntp_time",
    },
    options  => "-H ${ntp_server}",
    interval => 120,
    retry    => 30,
    package  => $operatingsystem ? {
      RedHat  => "nagios-plugins-ntp",
      CentOS  => "nagios-plugins-ntp",
      default => false,
    },
  }
}
