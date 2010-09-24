class monitoring::cron {

  monitoring::check { "Process: crond":
    codename => "check_crond_process",
    command  => "check_procs",
    options  => $operatingsystem ? {
      Debian => "-p 1 -w 1: -c 1: -C cron",
      /RedHat|CentOS/ => "-p 1 -w 1: -c 1: -C crond",
    },
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
