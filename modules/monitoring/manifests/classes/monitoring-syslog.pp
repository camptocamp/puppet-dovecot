class monitoring::syslog {

  if $ipaddress == $syslog_server {

    monitoring::check { "Process: syslogd":
      codename => "check_syslogd_process",
      command  => "check_procs",
      options  => "-p 1 -w 1:1 -c 1:1 -C syslog-ng",
      type     => "passive",
      server   => $nagios_nsca_server,
      package  => $operatingsystem ?{
        /RedHat|CentOS/ => "nagios-plugins-procs",
        default => false
      }
    }

  } else {

    monitoring::check { "Process: syslogd":
      codename => "check_syslogd_process",
      command  => "check_procs",
      options  => $operatingsystem ? {
        Debian => "-p 1 -w 1:1 -c 1:1 -C rsyslogd",
        /RedHat|CentOS/ => "-p 1 -w 1:1 -c 1:1 -C syslogd",
      },
      type     => "passive",
      server   => $nagios_nsca_server,
      package  => $operatingsystem ?{
        /RedHat|CentOS/ => "nagios-plugins-procs",
        default => false
      }
    }

    if ($operatingsystem =~ /RedHat|CentOS/) {

      monitoring::check { "Process: klogd":
        codename => "check_klogd_process",
        command  => "check_procs",
        options  => "-p 1 -w 1:1 -c 1:1 -C klogd",
        type     => "passive",
        server   => $nagios_nsca_server,
      }
    }

  }
}
