class monitoring::syslog {

  if $ipaddress == $syslog_server {

    monitoring::check { "Process: syslogd":
      codename => "check_syslogd_process",
      command  => "check_procs",
      options  => "-w 1:1 -c 1:1 -C syslog-ng",
    }

  } else {

    monitoring::check { "Process: syslogd":
      codename => "check_syslogd_process",
      command  => "check_procs",
      options  => $operatingsystem ? {
        Debian => "-w 1:1 -c 1:1 -C rsyslogd",
        RedHat => "-w 1:1 -c 1:1 -C syslogd",
      },
    }

    if $operatingsystem == "RedHat" {

      monitoring::check { "Process: klogd":
        codename => "check_klogd_process",
        command  => "check_procs",
        options  => "-w 1:1 -c 1:1 -C klogd",
      }
    }

  }
}
